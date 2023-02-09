resource "aws_ecr_repository" "new_private_repository" {
  name = "import-test-image"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = false
  }
  tags = {
    Kind = var.tag-kind
  }
}
