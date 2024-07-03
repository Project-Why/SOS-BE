variable "security_group_ids" {
  description = "Security group ids"
  type        = list(string)
}

variable "subnet_ids" {
  description = "Subnet ids"
  type        = list(string)
}

variable "ecs_vpc_id" {
  description = "The ID of the VPC for ECS"
  type        = string
}

variable "certificate_arn" {
  description = "The ARN of SSL certification"
  type        = string
}