module "network" {
  source = "./common/network"
}

module "security" {
  source = "./common/security"
  vpc_id             = module.network.vpc_id
}

resource "aws_rds_cluster_parameter_group" "aurora_pg" {
  family = "aurora-mysql8.0"

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  tags = {
    Name = "aurora-cluster-pg"
  }
}

resource "aws_db_parameter_group" "aurora_instance_pg" {
  name   = "aurora-instance-parameter-group"
  family = "aurora-mysql8.0"

  tags = {
    Name = "aurora-instance-pg"
  }
}

resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier              = "aurora-serverless-cluster"
  engine                          = "aurora-mysql"
  engine_version                  = "8.0.mysql_aurora.3.06.0"
  engine_mode                     = "provisioned"
  master_username                 = var.db_master_username
  master_password                 = var.db_master_password
  database_name                   = var.db_name
  backup_retention_period         = 1
  preferred_backup_window         = "07:00-09:00"
  db_subnet_group_name            = module.network.aurora_subnet_group_name
  vpc_security_group_ids          = [module.security.aurora_sg_id]
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora_pg.name
  
  serverlessv2_scaling_configuration {
    min_capacity = 0.5  # Aurora Capacity Units (ACUs)
    max_capacity = 16   # Aurora Capacity Units (ACUs)
  }

  tags = {
    Name = "aurora-serverless-cluster"
  }
}
resource "aws_rds_cluster_instance" "aurora_cluster_instance" {
  count                   = 1 
  identifier              = "aurora-serverless-instance-${count.index}"
  cluster_identifier      = aws_rds_cluster.aurora_cluster.id
  instance_class          = "db.serverless"
  engine                  = aws_rds_cluster.aurora_cluster.engine
  engine_version          = aws_rds_cluster.aurora_cluster.engine_version
  publicly_accessible     = true
  db_subnet_group_name    = module.network.aurora_subnet_group_name
  db_parameter_group_name = aws_db_parameter_group.aurora_instance_pg.name

  tags = {
    Name = "aurora-serverless-instance-${count.index}"
  }
}


output "aurora_cluster_endpoint" {
  value = aws_rds_cluster.aurora_cluster.endpoint
}

output "aurora_cluster_reader_endpoint" {
  value = aws_rds_cluster.aurora_cluster.reader_endpoint
}