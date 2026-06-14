variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Target environment (dev, stage, prod)"
  type        = string
  default     = "dev"
}

variable "vpc_id" {
  description = "The ID of the VPC (optional, defaults to AWS default VPC)"
  type        = string
  default     = ""
}

variable "subnet_ids" {
  description = "A list of subnets in the VPC (optional, defaults to default VPC subnets)"
  type        = list(string)
  default     = []
}

variable "project_name" {
  description = "Project name prefix for resources"
  type        = string
  default     = "mlops-platform"
}

variable "notebook_instance_type" {
  description = "SageMaker Notebook instance type"
  type        = string
  default     = "ml.t3.medium"
}
