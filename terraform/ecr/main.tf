# App
resource "aws_ecr_repository" "app_repository" {
  name = var.ecr_app_repository_name
}

resource "aws_ecr_lifecycle_policy" "app_lf_policy" {
  repository = aws_ecr_repository.app_repository.name
  
  policy = <<EOF
  {
      "rules": [
          {
              "rulePriority": 1,
              "description": "Keep only the last 10 untagged images.",
              "selection": {
                  "tagStatus": "untagged",
                  "countType": "imageCountMoreThan",
                  "countNumber": 10
              },
              "action": {
                  "type": "expire"
              }
          }
      ]
  }
  EOF
}

resource "aws_ecr_repository_policy" "app_policy" {
  repository = aws_ecr_repository.app_repository.name

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowECSAccess",
            "Effect": "Allow",
            "Principal": {
                "Service": "ecs-tasks.amazonaws.com"
            },
            "Action": [
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:GetDownloadUrlForLayer"
            ]
        }
    ]
  }
  EOF
}