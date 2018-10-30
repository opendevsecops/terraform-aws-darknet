output "log_group_name" {
  value = "${var.log_group_name}"
}

output "log_group_arn" {
  value = "${var.aws_cloudwatch_log_group.arn}"
}

output "log_retention_in_days" {
  value = "${var.log_retention_in_days}"
}

output "vpc_id" {
  value = "${var.vpc_id}"
}
