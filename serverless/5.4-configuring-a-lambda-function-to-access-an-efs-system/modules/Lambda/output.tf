output "lambda_arn" {
  value = aws_lambda_function.example_lambda.arn
}

output "lambda_security_group_id" {
  value = aws_security_group.lambda_sg.id
}