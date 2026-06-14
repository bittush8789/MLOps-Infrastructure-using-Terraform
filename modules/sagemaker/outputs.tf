output "domain_id" {
  description = "The ID of the SageMaker Domain"
  value       = aws_sagemaker_domain.this.id
}

output "domain_url" {
  description = "The URL of the SageMaker Domain"
  value       = aws_sagemaker_domain.this.url
}

output "notebook_arn" {
  description = "The ARN of the SageMaker Notebook Instance"
  value       = aws_sagemaker_notebook_instance.this.arn
}

output "user_profile_arn" {
  description = "The ARN of the SageMaker User Profile"
  value       = aws_sagemaker_user_profile.this.arn
}
