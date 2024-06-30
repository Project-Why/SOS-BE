module "network" {
  source = "./common/network"
}

module "security" {
  source     = "./common/security"
  db_vpc_id  = module.network.db_vpc_id
  ecs_vpc_id = module.network.ecs_vpc_id
}

module "iam" {
  source = "./common/iam"
}

module "cloudwatch" {
  source           = "./common/cloudwatch"
  ecs_service_name = var.ecs_service_name
}

module "ecr" {
  source                  = "./ecr"
  ecr_app_repository_name = var.ecr_app_repository_name
}

module "ecs" {
  source                      = "./ecs"
  aws_account_id              = var.aws_account_id
  region                      = var.region
  ecr_app_repository_name     = var.ecr_app_repository_name
  ecr_app_repository_tag      = var.ecr_app_repository_tag
  ecs_app_cluster_name        = var.ecs_app_cluster_name
  ecs_service_name            = var.ecs_service_name
  subnet_ids                  = module.network.ecs_private_subnet_ids
  security_group_ids          = [module.security.ecs_instance_sg_id]
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
}

module "rds" {
  source = "./rds"
  db_sg_id             = module.security.db_sg_id
  db_username          = var.db_master_username
  db_password          = var.db_master_password
  db_name              = var.db_name
  db_subnet_group_name = module.network.db_subnet_group_name
}