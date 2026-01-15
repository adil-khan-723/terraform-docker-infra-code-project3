module "vpc" {
  source             = "./modules/vpc"
  environment        = var.environment
  availability_zones = ["ap-south-1a", "ap-south-1b"]
}


module "security_groups" {
  source      = "./modules/security_groups"
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
}

module "internal_alb" {
  source                          = "./modules/alb_internal"
  environment                     = var.environment
  vpc_id                          = module.vpc.vpc_id
  internal_alb_sg_id              = module.security_groups.internal_alb_sg_id
  internal_alb_private_subnet_ids = module.vpc.private_subnet_ids
}

module "public_alb" {
  source                       = "./modules/alb_public"
  environment                  = var.environment
  vpc_id                       = module.vpc.vpc_id
  public_alb_sg_id             = module.security_groups.public_alb_sg_id
  public_alb_public_subnet_ids = module.vpc.public_subnet_ids
}

module "ecs_cluster" {
  source                    = "./modules/ecs_cluster"
  environment               = var.environment
  enable_container_insights = false
}

module "iam_role" {
  source = "./modules/iam"
  environment = var.environment
  ecr_repository_arn = module.ecr_repo.repository_arn

  task_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  ]
}

module "ecr_repo" {
  source = "./modules/ecr"
  environment = var.environment
  project_name = "oggy-app"
}

module "task_definition" {
  source = "./modules/task_definition"
  environment = var.environment
  project_name = "backend"
  cpu = 256
  memory = 1024
  task_definition_role_arn = module.iam_role.ecs_task_role_arn
  task_execution_role_arn = module.iam_role.ecs_execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "backend"
      image     = "${module.ecr_repo.repository_url}:backend-latest"
      essential = true

      portMappings = [
        {
          containerPort = 5001
          hostPort      = 5001
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/backend"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

module "frontend_task_definition" {
  source = "./modules/ecs-task-definition"

  project_name = "frontend"
  environment  = var.environment

  cpu    = 256
  memory = 1024

  task_execution_role_arn   = module.iam_role.ecs_execution_role_arn
  task_definition_role_arn = module.iam_role.ecs_task_role_arn

  container_definitions = jsonencode([
    {
      name      = "frontend"
      image     = "${module.ecr_repo.repository_url}:frontend-latest"
      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/frontend"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}