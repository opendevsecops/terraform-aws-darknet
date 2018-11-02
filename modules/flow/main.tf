data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

resource "aws_cloudwatch_log_group" "main" {
  name              = "${var.log_group_name}"
  retention_in_days = "${var.log_retention_in_days}"
}

resource "aws_iam_role" "main" {
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "main_policy" {
  name = "policy"
  role = "${aws_iam_role.main.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": [
        "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${var.log_group_name}:*:*",
        "arn:aws:logs:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:log-group:${var.log_group_name}"
      ]
    }
  ]
}
EOF
}

resource "aws_flow_log" "main" {
  log_group_name = "${var.log_group_name}"
  iam_role_arn   = "${aws_iam_role.main.arn}"

  traffic_type = "ALL"

  subnet_id = "${var.subnet_id}"
}

data "aws_ami" "main" {
  most_recent = true

  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

resource "aws_instance" "main" {
  ami           = "${data.aws_ami.main.id}"
  instance_type = "t3.nano"
  subnet_id     = "${var.subnet_id}"
}

resource "aws_network_interface" "main" {
  count     = 1
  subnet_id = "${var.subnet_id}"

  attachment {
    instance     = "${aws_instance.main.id}"
    device_index = "${count.index + 1}"
  }
}
