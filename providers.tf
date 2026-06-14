terraform {
  required_version = ">= 1.3.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.3.0"
    }
  }

  # Replace with actual S3 bucket and DynamoDB table names after backend is bootstrapped
  # backend "s3" {
  #   bucket         = "mlops-tf-remote-state-bucket"
  #   key            = "global/s3/terraform.tfstate"
  #   region         = "us-east-1"
  #   dynamodb_table = "mlops-tf-state-locks"
  #   encrypt        = true
  # }
}

provider "aws" {
  region = var.aws_region
}
