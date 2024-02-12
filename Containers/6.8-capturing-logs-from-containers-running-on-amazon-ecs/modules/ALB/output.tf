output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "blue_tg_group_arn" {
  value = aws_lb_target_group.blue_target_group.arn
}

output "blue_tg_group_name" {
  value = aws_lb_target_group.blue_target_group.name
}

output "green_tg_group_arn" {
  value = aws_lb_target_group.green_target_group.arn
}

output "green_tg_group_name" {
  value = aws_lb_target_group.green_target_group.name
}

output "alb_listener_arn" {
  value = aws_lb_listener.ecs_alb_listener.arn
}