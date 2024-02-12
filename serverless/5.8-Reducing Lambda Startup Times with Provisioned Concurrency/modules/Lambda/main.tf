resource "aws_lambda_function" "example_lambda" {
  filename      = var.file_name
  function_name = var.function_name
  role          = var.lambda_execution_role_arn
  handler       = var.handler
  runtime       = var.runtime
  publish       = true  # Publish a new version


  depends_on = [
    var.lambda_execution_role_arn
  ]
}


resource "aws_lambda_provisioned_concurrency_config" "example_provisioned_concurrency" {
  function_name                     = aws_lambda_function.example_lambda.function_name
  provisioned_concurrent_executions = 5
  qualifier                         = aws_lambda_function.example_lambda.version

  depends_on = [aws_lambda_function.example_lambda]
}
