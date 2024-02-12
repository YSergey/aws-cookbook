output "fargate_arn" {
  value = aws_lb_target_group.fargate_tg.arn
}