data "aws_caller_identity" "current" {}

locals {
  IAM = {
    sysname = "packaging-libraries-with-lambda-layers"
  }
}

locals {
  Lambda = {
    sysname = "packaging-libraries-with-lambda-layers"
    file_name = "modules/Lambda/requests-layer.zip"
    function_name = "lambda_function"
    handler = "lambda_function.lambda_handler"
    runtime = "python3.10"
    layer_name = "first-deploy"
  }
}
