terraform {
  backend "s3" {
    bucket         = "oggy-backend-bucket"
    key            = "terraform-docker-jenkins-ecs-project3/terraform.tfstate"
    region         = "ap-south-1"
    encrypt        = true
    dynamodb_table = "stateLock-table"
  }
}