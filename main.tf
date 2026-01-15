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