variable "environment" {
  description = "Target environment name"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to resources"
  type        = map(string)
  default     = {}
}
