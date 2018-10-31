const url = require('url');
const zlib = require('zlib');
const https = require('https');
const awsSdk = require('aws-sdk');

const ses = new awsSdk.SES();

const SRC_FIELD = 3;

const send = async (from, to, subject, body) => {
    return ses.sendEmail({
        Source: from,

        Destination: {
            ToAddresses: [
                to
            ]
        },

        Message: {
            Subject: {
                Charset: 'UTF-8',
                Data: subject
            },

            Body: {
                Text: {
                    Charset: 'UTF-8',
                    Data: body
                }
            }
        }
    }).promise();
};

const post = async (uri, body) => {
    body = JSON.stringify(body);

    const options = url.parse(uri);

    options.method = 'POST';

    options.headers = {
        'Content-Type': 'application/json',
        'Content-Length': body.length
    };

    return new Promise((resolve, reject) => {
        const req = https.request(options, (res) => {
            if (res.statusCode === 200) {
                res.on('end', () => {
                    resolve();
                });
            } else {
                reject(new Error(`Unexpected status code: ${res.statusCode}`));
            }
        });

        req.on('error', (error) => {
            reject(error);
        });

        req.end(body);
    });
};

const alert = async (meta) => {
    const blocks = [];

    Object.entries(meta || {}).forEach(([name, value]) => {
        blocks.push(`${name}: ${value}`);
    });

    const message = blocks.join('\n');

    console.log(process.env.NOTIFICATION_MESSAGE);
    console.log(message);

    if (process.env.SLACK_NOTIFICATION_URL) {
        console.log('Sending slack notification');

        const text = `${process.env.NOTIFICATION_MESSAGE}\n\`\`\`${message}\`\`\``;

        try {
            await post(process.env.SLACK_NOTIFICATION_URL, {text});
        } catch (e) {
            console.error(e);
        }
    }
};

exports.handler = async (event) => {
    const { awslogs } = event || {};
    const { data } = awslogs || {};

    const buff = Buffer.from(data || '', 'base64');
    const unzp = zlib.gunzipSync(buff);
    const json = JSON.parse(unzp);

    const { logEvents } = json || {};

    const ips = Array.from(
        new Set(
            (logEvents || [])
                .map((entry) => {
                    const { message } = entry || {};

                    const parts = (message || '').split(' ');
                    const src = parts[SRC_FIELD] || '';

                    return src;
                })
                .filter((entry) => {
                    return entry !== '-';
                })
        )
    );

    if (!ips.length) {
        return;
    }

    await alert({
        'Source IP Addresses': ips.join(', ')
    });
};
