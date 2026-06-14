output "log_group_arn" {
  description = "The ARN of the log group"
  value       = aws_cloudwatch_log_group.this.arn
}

output "log_group_name" {
  description = "The Name of the log group"
  value       = aws_cloudwatch_log_group.this.name
}
