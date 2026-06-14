output "s3_bucket_name" {
  description = "The name of the dataset S3 bucket"
  value       = module.s3.bucket_id
}

output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value       = module.ecr.repository_url
}

output "sagemaker_domain_id" {
  description = "The ID of the SageMaker Domain"
  value       = module.sagemaker.domain_id
}

output "sagemaker_notebook_arn" {
  description = "The ARN of the SageMaker Notebook instance"
  value       = module.sagemaker.notebook_arn
}

output "lambda_function_arn" {
  description = "The ARN of the Lambda function"
  value       = module.lambda.lambda_arn
}

output "cloudwatch_log_group_name" {
  description = "The Name of the CloudWatch Log Group"
  value       = module.cloudwatch.log_group_name
}
