locals {
  VPC = {
    sysname = "event-driven-launching-fargate"
    vpc_cidr = "10.0.0.0/16"

    subnet_a_cidr = "10.0.1.0/24"
    subnet_b_cidr = "10.0.2.0/24"

    subnet_a_az = "us-west-2a"
    subnet_b_az = "us-west-2b"
  }
}

locals {
  ECR = {
    sysname = "event-driven-launching-fargate"
    container_name = "my-app-container"
  }
}

locals {
  ECS = {
    sysname = "event-driven-launching-fargate"
  }
}

locals {
  ALB = {
    sysname = "event-launching-fargate"
  }
}

locals {
  S3 = {
    sysname = "event-driven-launching-fargate"
  }
}

locals {
  EventBridge = {
    sysname = "event-driven-launching-fargate"
  }
}

locals {
  Lambda = {
    sysname = "event-driven-launching-fargate"
    file_name = "modules/Lambda/lambda_function.zip"
    function_name = "lambda_function"
    handler = "lambda_function.lambda_handler"
    runtime = "python3.10"
  }
}