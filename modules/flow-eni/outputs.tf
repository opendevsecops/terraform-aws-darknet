output "log_group_name" {
  value = "${var.log_group_name}"
}

output "log_group_arn" {
  value = "${aws_cloudwatch_log_group.main.arn}"
}

output "log_retention_in_days" {
  value = "${var.log_retention_in_days}"
}

output "eni_id" {
  value = "${var.eni_id}"
}
