resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/mlops/${var.log_group_name}-${var.environment}"
  retention_in_days = var.retention_in_days

  tags = merge(
    {
      Name        = var.log_group_name
      Environment = var.environment
    },
    var.tags
  )
}
