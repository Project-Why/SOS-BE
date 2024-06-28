# App
resource "aws_ecr_repository" "app_repository" {
  name = var.ecr_app_repository_name
}

resource "aws_ecr_lifecycle_policy" "app_policy" {
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