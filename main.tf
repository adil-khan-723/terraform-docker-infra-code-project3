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

module "ecr_repo" {
  source       = "./modules/ecr"
  environment  = var.environment
  project_name = "oggy-app"
}

module "iam_role" {
  source             = "./modules/iam"
  environment        = var.environment
  ecr_repository_arn = module.ecr_repo.repository_arn

  task_role_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
  ]
}

module "backend_task_definition" {
  source       = "./modules/task_definition"
  environment  = var.environment
  project_name = "backend"

  cpu    = 256
  memory = 1024

  task_execution_role_arn   = module.iam_role.ecs_execution_role_arn
  task_definition_role_arn = module.iam_role.ecs_task_role_arn

  container_definitions = jsonencode([
    {
      name      = "backend"
      image     = "${module.ecr_repo.repository_url}:${var.backend_image_tag}"
      essential = true

      portMappings = [
        {
          containerPort = 5001
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
  source       = "./modules/task_definition"
  environment  = var.environment
  project_name = "frontend"

  cpu    = 256
  memory = 1024

  task_execution_role_arn   = module.iam_role.ecs_execution_role_arn
  task_definition_role_arn = module.iam_role.ecs_task_role_arn

  container_definitions = jsonencode([
    {
      name      = "frontend"
      image     = "${module.ecr_repo.repository_url}:${var.frontend_image_tag}"
      essential = true

      portMappings = [
        {
          containerPort = 80
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

module "ecs_service_backend" {
  source        = "./modules/ecs_service"
  service_name = "backend"
  environment  = var.environment

  cluster_arn         = module.ecs_cluster.ecs_cluster_arn
  task_definition_arn = module.backend_task_definition.task_definition_arn

  desired_count = 1
  launch_type   = "FARGATE"

  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.security_groups.backend_sg_id]

  target_group_arn = module.internal_alb.backend_target_group_arn
  container_name   = "backend"
  container_port   = 5001
}

module "ecs_service_frontend" {
  source        = "./modules/ecs_service"
  service_name = "frontend"
  environment  = var.environment

  cluster_arn         = module.ecs_cluster.ecs_cluster_arn
  task_definition_arn = module.frontend_task_definition.task_definition_arn

  desired_count = 1
  launch_type   = "FARGATE"

  subnet_ids         = module.vpc.private_subnet_ids
  security_group_ids = [module.security_groups.frontend_sg_id]

  target_group_arn = module.public_alb.frontend_target_group_arn
  container_name   = "frontend"
  container_port   = 80
}

module "jenkins_ec2" {
  instance_type = "t3.small"
  source = "./modules/jenkins_ec2"
  key_name = "oggy-key"
  subnet_id = module.vpc.public_subnet_ids[0]
  security_group_ids = [module.security_groups.jenkins_sg_id]
  instance_profile_name = module.iam_role.jenkins_instance_profile_name
  user_data = file("./install_jenkins.sh")
  environment = var.environment
  ami_id = data.aws_ami.ubuntu.id
}