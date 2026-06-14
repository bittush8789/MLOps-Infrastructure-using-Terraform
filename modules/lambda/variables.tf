variable "function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "role_arn" {
  description = "The ARN of the IAM role for Lambda execution"
  type        = string
}

variable "handler" {
  description = "The function entrypoint in the code"
  type        = string
  default     = "index.handler"
}

variable "runtime" {
  description = "Lambda runtime language"
  type        = string
  default     = "python3.9"
}

variable "environment" {
  description = "Target environment"
  type        = string
}

variable "environment_variables" {
  description = "Map of environment variables to assign to Lambda"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to assign to resources"
  type        = map(string)
  default     = {}
}
