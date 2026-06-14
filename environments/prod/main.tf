module "mlops" {
  source                 = "../../"
  aws_region             = var.aws_region
  environment            = var.environment
  project_name           = var.project_name
  notebook_instance_type = var.notebook_instance_type
  vpc_id                 = var.vpc_id
  subnet_ids             = var.subnet_ids
}
