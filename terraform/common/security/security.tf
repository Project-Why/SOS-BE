resource "aws_security_group" "db_sg" {
  description = "Allow DB instance access"
  vpc_id = var.db_vpc_id

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

resource "aws_security_group" "lb_sg" {
  name        = "lb-sg"
  description = "Security group for the load balancer"
  vpc_id      = var.ecs_vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
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
    Name = "lb-sg"
  }
}

resource "aws_security_group" "ecs_task_sg" {
  description = "Allow ECS task access"
  vpc_id      = var.ecs_vpc_id

  ingress {
    from_port                = 80
    to_port                  = 80
    protocol                 = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-task-sg"
  }
}

# resource "aws_security_group_rule" "allow_ec2_to_rds" {
#   type            = "ingress"
#   from_port       = 3306
#   to_port         = 3306
#   protocol        = "tcp"
#   security_group_id = aws_security_group.db_sg.id
#   source_security_group_id = aws_security_group.ecs_task_sg.id
# }

output "db_sg_id" {
  value = aws_security_group.db_sg.id
}

output "lb_sg_id" {
  value = aws_security_group.lb_sg.id
}

output "ecs_task_sg_id" {
  value = aws_security_group.ecs_task_sg.id
}