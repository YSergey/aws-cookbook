output "lambda_arn" {
  value = aws_lambda_function.example_lambda.arn
}

output "lambda_tg_arn" {
    value = aws_lb_target_group.lambda_tg.arn
}