data "aws_caller_identity" "current" {}

locals {
  VPC = {
    sysname = "configuring-an-alb-to-invoke-a-lambda-function"
    vpc_cidr = "10.0.0.0/16"

    subnet_a_cidr = "10.0.1.0/24"
    subnet_b_cidr = "10.0.2.0/24"

    subnet_a_az = "us-west-2a"
    subnet_b_az = "us-west-2b"
  }
}

locals {
  IAM = {
    sysname = "configuring-an-alb-to-invoke-a-lambda-function"
  }
}

locals {
  Lambda = {
    sysname = "configuring-an-alb-to-invoke-a-lambda-function"
    file_name = "modules/lambda/lambda_function_payload.zip"
    function_name = "lambda_function"
    handler = "lambda_function.lambda_handler"
    runtime = "python3.8"
  }
}

locals {
  ALB = {
    sysname = "configuring-an-alb-to-invoke-a-lambda-function"
    load_balancer_type = "application"
  }
}