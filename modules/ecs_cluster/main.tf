resource "aws_ecs_cluster" "cluster" {
  name = "ECS-cluster-${var.environment}"

  setting {
    name  = "containerInsights"
    value = var.enable_container_insights ? "enabled" : "disabled"
  }

  tags = {
    Name        = "ECS-cluster-${var.environment}"
    Environment = var.environment
  }
}