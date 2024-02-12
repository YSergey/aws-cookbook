resource "aws_lambda_function" "example_lambda" {
  function_name = var.function_name
  role          = var.lambda_execution_role_arn

  package_type = var.package_type
  image_uri = var.image_url

  depends_on = [
    var.lambda_execution_role_arn
  ]

}
