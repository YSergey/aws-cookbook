resource "random_pet" "this" {
  length    = 2
  separator = "-"
}

resource "aws_ecs_cluster" "example" {
  name = "example-cluster-${random_pet.this.id}"
}

resource "aws_ecs_service" "example" {
  name            = "example-service-${random_pet.this.id}"
  cluster         = aws_ecs_cluster.example.id
  task_definition = aws_ecs_task_definition.example.family
  launch_type     = "FARGATE"
  desired_count   = 1

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [var.ecs_security_group]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_log_group" "example" {
  name = "/ecs/example"
}

resource "aws_ecs_task_definition" "example" {
  family                   = "example"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.example_execution_role.arn
  task_role_arn            = aws_iam_role.example_execution_role.arn

  container_definitions = jsonencode([
  {
    name  = "example-container"
    image = "nginx:latest"
    portMappings = [
      {
        containerPort = 80
      }
    ],
    logConfiguration = {
      logDriver = "awslogs",
      options = {
        "awslogs-group" = "/ecs/example",
        "awslogs-region" = "us-west-2",
        "awslogs-stream-prefix" = "ecs"
      }
    }
  }
])
}

resource "aws_lb_target_group" "fargate_tg" {
  name     = "fargate-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_iam_role" "example_execution_role" {
  name = "example_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}
