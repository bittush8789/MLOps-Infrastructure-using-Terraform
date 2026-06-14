variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "environment" {
  description = "Target environment"
  type        = string
}

variable "image_mutability" {
  description = "The image mutability setting for the repository. Must be one of MUTABLE or IMMUTABLE."
  type        = string
  default     = "MUTABLE"
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
