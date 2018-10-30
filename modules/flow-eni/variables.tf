variable "log_group_name" {
  description = "The name of the CloudWatch log group"
  default     = "/opendevsecops/darknet"
}

variable "log_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group"
  default     = 90
}

variable "eni_id" {
  description = "Elastic Network Interface ID to attach to"
}

# depends_on workaround

variable "depends_on" {
  type    = "list"
  default = []
}
