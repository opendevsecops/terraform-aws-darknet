variable "log_group_name" {
  description = "The name of the CloudWatch log group"
  default     = "/opendevsecops/darknet"
}

variable "log_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group"
  default     = 90
}

variable "subnet_id" {
  description = "Subnet ID to attach to"
}

variable "lambda_name" {
  description = "A unique name for your Lambda Function"
  default     = "darknet_cloudwatch_handler"
}

variable "lambda_role_name" {
  description = "A unique name for your Lambda Function"
  default     = "darknet_cloudwatch_handler_role"
}

variable "lambda_log_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in lambda function log group"
  default     = 90
}

variable "notification_message" {
  description = "Notification message to send when threat identified"
  default     = "Danger, Will Robinson!"
}

variable "slack_notification_url" {
  description = "URL for slack notifications"
  default     = ""
}

# depends_on workaround

variable "depends_on" {
  type    = "list"
  default = []
}
