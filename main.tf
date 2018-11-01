module "flow" {
  source = "modules/flow"

  log_group_name        = "${var.log_group_name}"
  log_retention_in_days = "${var.log_retention_in_days}"
  subnet_id             = "${var.subnet_id}"
}

module "lambda" {
  source = "modules/lambda"

  name                  = "${var.lambda_name}"
  role_name             = "${var.lambda_role_name}"
  log_retention_in_days = "${var.lambda_log_retention_in_days}"

  target_log_group_name = "${module.flow.log_group_name}"

  notification_message   = "${var.notification_message}"
  slack_notification_url = "${var.slack_notification_url}"

  depends_on = ["${module.flow.log_group_name}"]
}
