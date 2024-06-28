resource "aws_ecs_cluster" "app_cluster" {
  name = var.ecs_app_cluster_name
}

resource "aws_ecs_task_definition" "app_task" {
  family                   = var.ecs_service_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.ecs_task_execution_role_arn
  task_role_arn            = var.ecs_task_execution_role_arn

  container_definitions = jsonencode([{
    name      = var.ecs_service_name
    image     = "${var.aws_account_id}.dkr.ecr.${var.region}.amazonaws.com/${var.ecr_app_repository_name}:latest"
    essential = true
    portMappings = [{
      containerPort = 80
      hostPort      = 80
    }]
  }])
}

resource "aws_cloudwatch_event_rule" "ecr_image_update" {
  name        = var.ecr_update_event_name
  description = "Triggered when an image is pushed to ECR"
  event_pattern = jsonencode({
    "source"   : ["aws.ecr"],
    "detail-type": ["ECR Image Action"],
    "detail"   : {
      "action-type": ["PUSH"],
      "repository-name": [var.ecr_app_repository_name]
    }
  })
}

resource "aws_cloudwatch_event_target" "ecs_task_target" {
  rule = aws_cloudwatch_event_rule.ecr_image_update.name
  target_id = "ecs_task"
  arn = aws_lambda_function.ecs_task_updater.arn
}

resource "aws_lambda_function" "ecs_task_updater" {
  filename         = "ecs_task_updater.zip"
  function_name    = "ecs_task_updater"
  role             = var.lambda_execution_role_arn
  handler          = "ecs_task_updater.handler"
  runtime          = "python3.8"
  source_code_hash = filebase64sha256("ecs_task_updater.zip")

  environment {
    variables = {
      ECS_CLUSTER_NAME    = var.ecs_app_cluster_name
      ECS_SERVICE_NAME    = var.ecs_service_name
      ECS_TASK_DEFINITION = aws_ecs_task_definition.app_task.arn
    }
  }
}

resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ecs_task_updater.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ecr_image_update.arn
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
}

output "service_name" {
  value = aws_ecs_service.service.name
}

resource "aws_launch_configuration" "ecs_instance" {
  name          = "ecs-launch-configuration"
  image_id      = "ami-061a125c7c02edb39" // Amazon Linux 2023 AMI 2023.5.20240624.0 x86_64 HVM kernel-6.1
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ecs_instances" {
  launch_configuration = aws_launch_configuration.ecs_instance.id
  min_size             = 1
  max_size             = 2
  desired_capacity     = 1
  vpc_zone_identifier  = var.subnet_ids

  tag {
    key                 = "Name"
    value               = "ecs-instance"
    propagate_at_launch = true
  }
}

data "aws_instances" "ecs_instances" {
  filter {
    name   = "tag:Name"
    values = ["ecs-instance"]
  }

  depends_on = [aws_autoscaling_group.ecs_instances]
}

resource "aws_eip" "ecs_instance_eip" {
  instance = element(data.aws_instances.ecs_instances.ids, 0)
  domain   = "vpc"
}