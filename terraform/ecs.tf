# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_execution_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# ECS Task Definition: Backend
resource "aws_ecs_task_definition" "backend" {
  family                   = "devops-backend-task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "backend"
      image     = var.backend_image
      portMappings = [{
        containerPort = 80
        hostPort      = 80
      }]
      essential = true
    }
  ])
}

# ECS Task Definition: Frontend
resource "aws_ecs_task_definition" "frontend" {
  family                   = "devops-frontend-task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "frontend"
      image     = var.frontend_image
      portMappings = [{
        containerPort = 80
        hostPort      = 80
      }]
      essential = true
    }
  ])
}

# ECS Service: Backend
resource "aws_ecs_service" "backend" {
  name            = "devops-backend-service"
  cluster         = aws_ecs_cluster.devops_cluster.id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = 1

  network_configuration {
    subnets         = aws_subnet.public[*].id
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.backend.arn
    container_name   = "backend"
    container_port   = 80
  }

  depends_on = [aws_lb_listener_rule.api_rule]
}

# ECS Service: Frontend
resource "aws_ecs_service" "frontend" {
  name            = "devops-frontend-service"
  cluster         = aws_ecs_cluster.devops_cluster.id
  launch_type     = "FARGATE"
  task_definition = aws_ecs_task_definition.frontend.arn
  desired_count   = 1

  network_configuration {
    subnets         = aws_subnet.public[*].id
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.frontend.arn
    container_name   = "frontend"
    container_port   = 80
  }

  depends_on = [aws_lb_listener.http]
}
