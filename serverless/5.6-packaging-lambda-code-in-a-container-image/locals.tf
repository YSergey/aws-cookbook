data "aws_caller_identity" "current" {}

locals {
  IAM = {
    sysname = "packaging-lambda-code-in-a-container-image"
  }
}

locals {
  Lambda = {
    sysname = "packaging-lambda-code-in-a-container-image"
    function_name = "lambda_function"
    package_type  = "Image"
  }
}

locals {
  ECR = {
    sysname = "packaging-lambda-code-in-a-container-image"
  }
}
