variable "log_group_name" {
  description = "The name of the log group"
  type        = string
}

variable "retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group"
  type        = number
  default     = 7
}

variable "environment" {
  description = "Target environment"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resource"
  type        = map(string)
  default     = {}
}
