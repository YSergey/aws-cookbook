output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "blue_tg_group_arn" {
  value = aws_lb_target_group.blue_target_group.arn
}