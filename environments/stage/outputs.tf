output "s3_bucket_name" {
  value = module.mlops.s3_bucket_name
}

output "ecr_repository_url" {
  value = module.mlops.ecr_repository_url
}

output "sagemaker_domain_id" {
  value = module.mlops.sagemaker_domain_id
}

output "sagemaker_notebook_arn" {
  value = module.mlops.sagemaker_notebook_arn
}

output "lambda_function_arn" {
  value = module.mlops.lambda_function_arn
}

output "cloudwatch_log_group_name" {
  value = module.mlops.cloudwatch_log_group_name
}
