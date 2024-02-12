data "aws_caller_identity" "current" {}

locals {
  VPC = {
    sysname = "configuring-a-lambda-function-to-access-an-EFS-File-System"
    vpc_cidr = "10.0.0.0/16"

    subnet_a_cidr = "10.0.1.0/24"
    subnet_b_cidr = "10.0.2.0/24"

    subnet_a_az = "us-west-2a"
    subnet_b_az = "us-west-2b"
  }
}

locals {
  IAM = {
    sysname = "lambda-function-to-access-an-EFS-File-System"
  }
}

locals {
  Lambda = {
    sysname = "configuring-a-lambda-function-to-access-an-EFS-File-System"
    file_name = "modules/Lambda/lambda_function.zip"
    function_name = "lambda_function"
    handler = "lambda_function.lambda_handler"
    runtime = "python3.10"
  }
}

locals {
  EC2_A = {
    sysname = "encrypting-storage-of-RDS-EC2-A"
    create_endpoint = true
    instance_type = "t2.micro"
    availability_zone = "us-west-2a"
  }
}

