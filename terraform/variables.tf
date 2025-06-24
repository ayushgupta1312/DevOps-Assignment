# AWS Region
variable "aws_region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "ap-south-1"
}

# VPC CIDR
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Public Subnet CIDRs
variable "public_subnet_cidrs" {
  description = "List of public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

# Availability Zones
variable "availability_zones" {
  description = "List of AZs to use"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]
}

# ECS task CPU and memory
variable "task_cpu" {
  description = "CPU units for ECS tasks"
  type        = number
  default     = 256
}

variable "task_memory" {
  description = "Memory (MB) for ECS tasks"
  type        = number
  default     = 512
}

# ECR Image tags (will be passed via tfvars or pipeline later)
variable "backend_image" {
  description = "Full ECR URI for backend image"
  type        = string
}

variable "frontend_image" {
  description = "Full ECR URI for frontend image"
  type        = string
}