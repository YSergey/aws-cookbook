resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.sysname}-ecs-cluster"
}

# ECSタスク用セキュリティグループ
resource "aws_security_group" "ecs_sg" {
  name        = "${var.sysname}-ecs-sg"
  description = "Security group for ECS"
  vpc_id      = var.vpc_id

  # ALBからのインバウンドトラフィックを許可
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  # HTTPSへのアウトバウンドトラフィックを許可
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Service
resource "aws_ecs_service" "ecs_service" {
  name            = "${var.sysname}-ecs-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.blue.arn
  launch_type     = "FARGATE"

  desired_count   = 1

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [ aws_security_group.ecs_sg.id ]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.blue_tg_group_arn  
    container_name   = "my-blue-container"
    container_port   = 80
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }
}

#Create an ECS Task Definition
resource "aws_ecs_task_definition" "blue" {
  family                = "${var.sysname}-blue"
  network_mode          = "awsvpc"
  execution_role_arn    = var.ecs_iam_role
  requires_compatibilities = ["FARGATE"]
  cpu                   = 256
  memory    = 512

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }

  container_definitions = jsonencode([{
    name      = "my-blue-container"
    image     = "129972428809.dkr.ecr.us-west-2.amazonaws.com/updating-containers-with-blue-green-deployments-container-repo:blue"
    cpu       = 256
    memory    = 512
    essential = true
    portMappings = [
      {
        containerPort = 80
        protocol      = "tcp"
      }
    ]}])
}
