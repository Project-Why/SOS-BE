resource "aws_ecs_cluster" "app_cluster" {
  name = var.ecs_app_cluster_name
}

resource "aws_ecs_task_definition" "app_task" {
  family                   = var.ecs_service_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn

  container_definitions = jsonencode([{
    name      = var.ecs_service_name
    image     = "${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.ecr_app_repository_name}:${var.ecr_app_repository_tag}"
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group"         = "/ecs/${var.ecs_service_name}"
        "awslogs-region"        = var.region
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }])

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

resource "aws_ecs_service" "service" {
  name            = var.ecs_service_name
  cluster         = aws_ecs_cluster.app_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_ids
    security_groups  = var.security_group_ids
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.app_tg_arn
    container_name   = var.ecs_service_name
    container_port   = 80
  }

  depends_on = [var.app_lb_listener_arn]
}

output "service_name" {
  value = aws_ecs_service.service.name
}