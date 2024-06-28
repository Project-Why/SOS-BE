resource "aws_db_parameter_group" "db_instance_pg" {
  name   = "db-instance-parameter-group"
  family = "mysql8.0"

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  tags = {
    Name = "db-instance-pg"
  }
}

resource "aws_db_instance" "db_instance" {
  identifier              = "sos-instance"
  instance_class          = "db.t3.micro"
  engine                  = "mysql"
  engine_version          = "8.0.34"
  username                = var.db_username
  password                = var.db_password
  allocated_storage       = 20
  db_subnet_group_name    = var.db_subnet_group_name
  vpc_security_group_ids  = [var.db_sg_id]
  skip_final_snapshot     = true
  publicly_accessible     = true
}