output "lambda_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.this.arn
}

output "lambda_name" {
  description = "The Name of the Lambda function"
  value       = aws_lambda_function.this.function_name
}
