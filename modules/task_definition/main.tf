resource "aws_ecs_task_definition" "this" {
    family = "${var.project_name}-${var.environment}"
    requires_compatibilities = ["FARGATE"]
    network_mode = "awsvpc"
    cpu = var.cpu
    memory = var.memory
    execution_role_arn = var.task_execution_role_arn
    task_role_arn = var.task_definition_role_arn

    container_definitions = var.container_definitions

    runtime_platform {
        operating_system_family = "LINUX"
        cpu_architecture = "X86_64"
    }

    tags = {
        Name = "${var.project_name}-${var.environment}"
        Environment = var.environment
    }
}