resource "aws_ecs_cluster" "foo" {
  name = var.target-cluster-name

  setting {
    name  = "containerInsights"
    value = "disabled"
  }
}
