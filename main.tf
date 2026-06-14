data "aws_vpc" "default" {
  count   = var.vpc_id == "" ? 1 : 0
  default = true
}

data "aws_subnets" "default" {
  count = length(var.subnet_ids) == 0 ? 1 : 0
  filter {
    name   = "vpc-id"
    values = [var.vpc_id == "" ? data.aws_vpc.default[0].id : var.vpc_id]
  }
}

locals {
  vpc_id     = var.vpc_id == "" ? data.aws_vpc.default[0].id : var.vpc_id
  subnet_ids = length(var.subnet_ids) == 0 ? slice(data.aws_subnets.default[0].ids, 0, 2) : var.subnet_ids
  tags = {
    Project   = var.project_name
    ManagedBy = "Terraform"
  }
}

# 1. IAM Module
module "iam" {
  source      = "./modules/iam"
  environment = var.environment
  tags        = local.tags
}

# 2. S3 Module (Data Lake / Model Artifacts Storage)
module "s3" {
  source      = "./modules/s3"
  bucket_name = "${var.project_name}-artifacts-${var.environment}"
  environment = var.environment
  tags        = local.tags
}

# 3. ECR Module (Docker Repository for training/inference images)
module "ecr" {
  source          = "./modules/ecr"
  repository_name = "${var.project_name}-repo-${var.environment}"
  environment     = var.environment
  tags            = local.tags
}

# 4. CloudWatch Module (Monitoring & Logs)
module "cloudwatch" {
  source          = "./modules/cloudwatch"
  log_group_name  = "${var.project_name}-logs"
  environment     = var.environment
  tags            = local.tags
}

# 5. SageMaker Module (Notebooks, domain configuration)
module "sagemaker" {
  source        = "./modules/sagemaker"
  domain_name   = "${var.project_name}-domain"
  role_arn      = module.iam.sagemaker_role_arn
  vpc_id        = local.vpc_id
  subnet_ids    = local.subnet_ids
  notebook_name = "${var.project_name}-notebook"
  instance_type = var.notebook_instance_type
  environment   = var.environment
  tags          = local.tags
}

# 6. Lambda Module (Inference triggering / model notification pipeline)
module "lambda" {
  source        = "./modules/lambda"
  function_name = "${var.project_name}-trigger"
  role_arn      = module.iam.lambda_role_arn
  environment   = var.environment
  environment_variables = {
    S3_BUCKET    = module.s3.bucket_id
    ECR_REPO_URL = module.ecr.repository_url
    SM_DOMAIN_ID = module.sagemaker.domain_id
  }
  tags = local.tags
}
