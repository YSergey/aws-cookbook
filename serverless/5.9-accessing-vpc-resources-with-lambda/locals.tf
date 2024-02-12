data "aws_caller_identity" "current" {}

locals {
  IAM = {
    sysname = "accessing-vpc-resources-with-lambda"
  }
}

locals {
  VPC = {
    sysname = "accessing-vpc-resources-with-lambda"
    vpc_cidr = "10.0.0.0/16"

    subnet_a_cidr = "10.0.1.0/24"
    subnet_b_cidr = "10.0.2.0/24"

    subnet_a_az = "us-west-2a"
    subnet_b_az = "us-west-2b"
  }
}

locals {
  Lambda = {
    sysname = "accessing-vpc-resources-with-lambda"
    file_name = "modules/Lambda/lambda_function.zip"
    function_name = "lambda_function"
    handler = "lambda_function.lambda_handler"
    runtime = "python3.10"
  }
}

locals {
  ElasticCache = {
    sysname = "accessing-vpc-resources-with-lambda"
  }
}