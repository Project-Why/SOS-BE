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

module "lb" {
  source = "./common/lb"
  security_group_ids = [module.security.lb_sg_id]
  subnet_ids         = module.network.ecs_public_subnet_ids
  ecs_vpc_id         = module.network.ecs_vpc_id
  certificate_arn    = var.certificate_arn
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
  security_group_ids          = [module.security.ecs_task_sg_id]
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  app_tg_arn                  = module.lb.app_tg_arn
  app_lb_listener_arn         = module.lb.app_lb_listener_arn
}

module "rds" {
  source = "./rds"
  db_sg_id             = module.security.db_sg_id
  db_instance_name     = var.db_instance_name
  db_username          = var.db_username
  db_password          = var.db_password
  db_name              = var.db_name
  db_subnet_group_name = module.network.db_subnet_group_name
}