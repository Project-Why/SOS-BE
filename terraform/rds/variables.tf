variable "db_sg_id" {
    description = "Security group id for db instance"
    type = string
}

variable "db_username" {
    description = "Root user name"
    type = string
}

variable "db_password" {
    description = "Root user password"
    type = string
}

variable "db_name" {
    description = "The name of database"
    type = string
}

variable "db_subnet_group_name" {
    description = "Subnet group name for db"
    type = string
}