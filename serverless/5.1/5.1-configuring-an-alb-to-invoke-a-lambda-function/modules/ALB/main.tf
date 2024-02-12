resource "aws_lb" "my_lb" {
  name               = "my-lb"
  internal           = false
  load_balancer_type = var.load_balancer_type
  security_groups    = [ aws_security_group.alb_sg.id ]
  subnets            = var.subnet_ids

  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true
}

# ALB Security Group
resource "aws_security_group" "alb_sg" {
  vpc_id = var.vpc_id
  
  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.my_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "404: Not Found"
      status_code  = "404"
    }
  }
}

resource "aws_lb_listener_rule" "listener" {
  listener_arn = aws_lb_listener.front_end.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = var.lambda_tg_arn  
  }

  condition {
    path_pattern {
      values = ["/function"]
    }
  }
}

resource "aws_lambda_permission" "allow_lb" {
  statement_id  = "AllowExecutionFromLoadBalancer"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function_name
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = var.lambda_tg_arn  
}