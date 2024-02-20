output "alb_dns_name" {
  value = aws_lb.my_lb.dns_name
}

output "aws_lambda_permission" {
  value = aws_lambda_permission.allow_lb
}