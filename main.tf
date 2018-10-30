module "flow" {
  source = "modules/flow-subnet"

  log_group_name        = "${var.log_group_name}"
  log_retention_in_days = "${var.log_retention_in_days}"
  subnet_id             = "${var.subnet_id}"
}

module "lambda" {
  source = "modules/lambda"

  log_group_name = "${module.flow.log_group_name}"

  depends_on = ["${module.flow.log_group_name}"]
}
