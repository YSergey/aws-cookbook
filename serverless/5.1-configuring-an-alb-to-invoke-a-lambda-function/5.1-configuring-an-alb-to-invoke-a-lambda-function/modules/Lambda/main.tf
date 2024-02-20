resource "aws_lambda_function" "example_lambda" {
  filename      = var.file_name
  function_name = var.function_name
  role          = aws_iam_role.lambda_execution_role.arn
  handler       = var.handler
  runtime       = var.runtime

  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = var.security_group_ids
  }

  depends_on = [
    aws_iam_role.lambda_execution_role.arn
  ]
}

resource "aws_lb_target_group" "lambda_tg" {
  name        = "lambda-target-group"
  target_type = "lambda"
}

resource "aws_lb_target_group_attachment" "lambda_tg_attachment" {
  target_group_arn = aws_lb_target_group.lambda_tg.arn
  target_id        = aws_lambda_function.example_lambda.arn
}
