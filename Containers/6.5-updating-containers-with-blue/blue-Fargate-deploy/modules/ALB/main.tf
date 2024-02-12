resource "aws_lb" "ecs_lb" {
  name                       = "${var.sysname}-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [ aws_security_group.alb_sg.id ] 
  subnets                    = var.subnet_ids
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.sysname}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  // インターネットからのHTTPトラフィックを許可
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# ALBのターゲットグループの作成
resource "aws_lb_target_group" "blue_target_group" {
  name        = "${var.sysname}-tg-blue"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
}

resource "aws_lb_listener" "ecs_alb_listener" {
  load_balancer_arn = aws_lb.ecs_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue_target_group.arn
  }
}