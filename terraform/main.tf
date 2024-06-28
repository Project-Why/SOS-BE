module "network" {
  source = "./common/network"
}

module "security" {
  source = "./common/security"
  vpc_id = module.network.vpc_id
}

module "iam" {
  source = "./common/iam"
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
  ecr_update_event_name       = var.ecr_update_event_name
  ecs_app_cluster_name        = var.ecs_app_cluster_name
  ecs_service_name            = var.ecs_service_name
  subnet_ids                  = module.network.subnet_ids
  security_group_ids          = [module.security.ecs_instance_sg_id]
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  lambda_execution_role_arn   = module.iam.lambda_execution_role_arn
}

module "rds" {
  source = "./rds"
  db_sg_id = module.security.db_sg_id
  db_username = var.db_master_username
  db_password = var.db_master_password
  db_subnet_group_name = module.network.db_subnet_group_name
}