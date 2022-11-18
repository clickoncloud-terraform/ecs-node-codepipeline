resource "aws_ecr_repository" "docker_repo" {
  name                 = var.IMAGE_REPO_NAME
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}

# output "OUT-ECR-REPO" {
#   value = aws_ecr_repository.docker_repo.repository_url

# }