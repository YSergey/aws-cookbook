data "aws_caller_identity" "current" {}

locals {
  IAM = {
    sysname = "running-trusted-code-in-lambda"
  }
}

locals {
  Lambda = {
    sysname = "running-trusted-code-in-lambda"
    function_name = "lambda_function"
    handler = "lambda_function.lambda_handler"
    runtime = "python3.10"
  }
}

locals {
  S3 = {
    sysname = "running-trusted-code-in-lambda"
    source_code_bucket = "running-trusted-code-in-lambda-source-bucket"
    source_path = "modules/S3/lambda_function.zip"
    signed_code_bucket = "running-trusted-code-in-lambda-signed-bucket"
    object_key = "lambda-s3"
  }
}

locals {
  Signed = {
    sysname = "running-trusted-code-in-lambda"
  }
}