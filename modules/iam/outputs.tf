output "sagemaker_role_arn" {
  description = "The ARN of the SageMaker Execution Role"
  value       = aws_iam_role.sagemaker_execution.arn
}

output "lambda_role_arn" {
  description = "The ARN of the Lambda Execution Role"
  value       = aws_iam_role.lambda_execution.arn
}
