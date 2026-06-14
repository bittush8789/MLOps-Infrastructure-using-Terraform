variable "domain_name" {
  description = "The SageMaker domain name"
  type        = string
}

variable "role_arn" {
  description = "The ARN of the SageMaker Execution IAM Role"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC for SageMaker"
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs in the VPC for SageMaker"
  type        = list(string)
}

variable "notebook_name" {
  description = "The SageMaker Notebook Instance name"
  type        = string
}

variable "instance_type" {
  description = "The SageMaker Notebook instance type"
  type        = string
  default     = "ml.t3.medium"
}

variable "environment" {
  description = "Target environment"
  type        = string
}

variable "tags" {
  description = "Tags to assign to resources"
  type        = map(string)
  default     = {}
}
