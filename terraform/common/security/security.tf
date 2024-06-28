resource "aws_security_group" "db_sg" {
  description = "Allow DB instance access"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-sg"
  }
}

resource "aws_security_group" "ecs_instance_sg" {
  description = "Allow ECS instance access"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-instance-sg"
  }
}

resource "aws_security_group_rule" "allow_ec2_to_rds" {
  type            = "ingress"
  from_port       = 3306
  to_port         = 3306
  protocol        = "tcp"
  security_group_id = aws_security_group.db_sg.id
  source_security_group_id = aws_security_group.ecs_instance_sg.id
}

output "db_sg_id" {
  value = aws_security_group.db_sg.id
}

output "ecs_instance_sg_id" {
  value = aws_security_group.ecs_instance_sg.id
}