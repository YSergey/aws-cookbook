output "lambda_function_name" {
  value = aws_lambda_function.example_lambda.function_name
}

output "lambda_tg_arn" {
  value = aws_lb_target_group.lambda_tg.arn
}

output "function_name" {
  value = aws_lambda_function.example_lambda.function_name
}