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
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups = [ var.alb_sg_id ]
  }
}

#Create an ECS Task Definition
resource "aws_ecs_task_definition" "blue" {
  family                = "${var.sysname}-blue"
  network_mode          = "awsvpc"
  execution_role_arn    = var.ecs_iam_role
  cpu                   = 256

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

# ECSサービスのセキュリティグループを指定
resource "aws_ecs_service" "blue_service" {
  name            = "${var.sysname}-blue-service"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.blue.arn
  launch_type     = "EC2" // FARGATEを使っている場合は"FARGATE"に変更

  desired_count   = 1

  network_configuration {
   subnets         = var.subnet_ids
   security_groups = [ aws_security_group.ecs_sg.id ]
 }

  load_balancer {
    target_group_arn = var.blue_tg_group_arn
    container_name   = "my-blue-container" // タスク定義のコンテナ名
    container_port   = 80
  }
}

# resource "aws_ecs_task_definition" "green" {
#   family                = "${var.sysname}-green"
#   network_mode          = "bridge"
#   container_definitions = file("./modules/ECS/task-definition-blue.json")
# }

# Amazon Linux 2 AMI
data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/recommended/image_id"
}

resource "aws_launch_configuration" "ecs_launch_configuration" {
  name_prefix     = "${var.sysname}-ecs"
  image_id        = data.aws_ssm_parameter.ecs_ami.value
  instance_type   = "t2.micro"
  iam_instance_profile = var.instance_profile
  user_data       = <<-EOF
                    #!/bin/bash
                    echo ECS_CLUSTER=${aws_ecs_cluster.ecs_cluster.name} >> /etc/ecs/ecs.config
                    EOF
  lifecycle {
    create_before_destroy = true
  }
}


# Auto Scaling Group
resource "aws_autoscaling_group" "ecs_autoscaling_group" {
  launch_configuration = aws_launch_configuration.ecs_launch_configuration.id
  vpc_zone_identifier  = var.subnet_ids  # VPCのサブネットIDのリスト
  min_size             = 1
  max_size             = 1

  tag {
    key                 = "Name"
    value               = "ECS Instance - ${var.sysname}"
    propagate_at_launch = true
  }
}

