variable "aws_account_id" {
  description = "AWS account id"
}

variable "region" {
  description = "The AWS region"
}

variable "ecr_app_repository_name" {
  description = "The name of the ECR repository for the application server image"
  type        = string
}

variable "ecr_app_repository_tag" {
  description = "The tag of the ECR repository for the application server image"
  type        = string
}

variable "ecs_app_cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
}

variable "ecs_service_name" {
  description = "The name of the ECS service"
  type        = string
}

variable "security_group_ids" {
  description = "Security group ids"
  type        = list(string)
}

variable "subnet_ids" {
  description = "Subnet ids"
  type        = list(string)
}

variable "ecs_task_execution_role_arn" {
  description = "IAM role arn for task execution"
  type        = string
}

variable "app_tg_arn" {
  description = "The ARN of Load balancer tag group"
  type        = string
}

variable "app_lb_listener_arn" {
  description = "The ARN of Load balancing listener"
  type        = string
}