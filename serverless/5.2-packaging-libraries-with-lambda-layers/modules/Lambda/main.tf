resource "aws_lambda_layer_version" "lambda_layer" {
  filename   = var.file_name
  layer_name = var.layer_name

  # Ensure Python runtime compatibility
  compatible_runtimes = [ var.runtime ]
}

resource "aws_lambda_function" "my_lambda" {
  function_name = var.function_name
  handler       = var.handler 
  role          = var.lambda_execution_role_arn
  runtime       = var.runtime

  # Specify your Lambda code here
  filename = var.file_name

  layers = [
    aws_lambda_layer_version.lambda_layer.arn
  ]

  environment {
    variables = {
      LAYER_VERSION = aws_lambda_layer_version.lambda_layer.version
    }
  }
}
