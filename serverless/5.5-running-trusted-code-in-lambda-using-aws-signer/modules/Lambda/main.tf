resource "aws_lambda_function" "example_lambda" {
  function_name = var.function_name
  role          = var.lambda_execution_role_arn
  handler       = var.handler
  runtime       = var.runtime

  s3_bucket = var.signed_code_bucket
  s3_key    = "signed/lambda-s3-signed21281729-47b3-4e57-9494-52dbbca8d5fe"

  code_signing_config_arn = var.lambda_code_signing_config_arn

  depends_on = [
    var.lambda_execution_role_arn
  ]

}
