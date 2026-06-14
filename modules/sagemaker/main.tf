resource "aws_sagemaker_domain" "this" {
  domain_name             = "${var.domain_name}-${var.environment}"
  auth_mode               = "IAM"
  vpc_id                  = var.vpc_id
  subnet_ids              = var.subnet_ids
  app_network_access_type = "PublicOnly"

  default_user_settings {
    execution_role = var.role_arn
  }

  tags = merge(
    {
      Name        = "${var.domain_name}-${var.environment}"
      Environment = var.environment
    },
    var.tags
  )
}

resource "aws_sagemaker_user_profile" "this" {
  domain_id         = aws_sagemaker_domain.this.id
  user_profile_name = "mlops-engineer-${var.environment}"

  user_settings {
    execution_role = var.role_arn
  }

  tags = merge(
    {
      Name        = "mlops-user-${var.environment}"
      Environment = var.environment
    },
    var.tags
  )
}

resource "aws_sagemaker_notebook_instance" "this" {
  name          = "${var.notebook_name}-${var.environment}"
  role_arn      = var.role_arn
  instance_type = var.instance_type

  tags = merge(
    {
      Name        = "${var.notebook_name}-${var.environment}"
      Environment = var.environment
    },
    var.tags
  )
}
