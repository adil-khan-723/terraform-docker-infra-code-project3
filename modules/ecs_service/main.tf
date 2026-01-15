resource "aws_ecs_service" "this" {
    name  =  "${var.service_name}-${var.environment}"
    cluster = var.cluster_arn
    task_definition = var.task_definition_arn
    desired_count = var.desired_count
    launch_type = var.launch_type

    network_configuration {
      subnets = var.subnet_ids
      security_groups = var.security_group_ids
      assign_public_ip = false
    }

    load_balancer {
      target_group_arn = var.target_group_arn
      container_name = var.container_name
      container_port = var.container_port
    }

    deployment_minimum_healthy_percent = 50
    deployment_maximum_percent = 200

    lifecycle {
      ignore_changes = [ task_definition ]
    }

    tags = {
        Name = "${var.service_name}-${var.environment}"
        Environment = var.environment
    }
}