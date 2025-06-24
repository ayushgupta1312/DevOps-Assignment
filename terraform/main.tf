provider "aws" {
  region = var.aws_region
}

# Create ECS Cluster
resource "aws_ecs_cluster" "devops_cluster" {
  name = "devops-cluster"
}
