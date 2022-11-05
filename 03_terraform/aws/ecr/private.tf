resource "aws_ecr_repository" "new_private_repository" {
  name = var.target-repository-name
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = false
  }
  tags = {
    Kind = var.tag-kind
  }
}
