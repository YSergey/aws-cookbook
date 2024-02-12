locals {
  VPC = {
    sysname = "updating-containers-with-blue-green-deployments"
    vpc_cidr = "10.0.0.0/16"

    subnet_a_cidr = "10.0.1.0/24"
    subnet_b_cidr = "10.0.2.0/24"

    subnet_a_az = "us-west-2a"
    subnet_b_az = "us-west-2b"
  }
}

locals {
  ECR = {
    sysname = "updating-containers-with-blue-green-deployments"
  }
}

locals {
  ECS = {
    sysname = "blue-green-deployments"
  }
}

locals {
  ALB = {
    sysname = "blue-green-deployments"
  }
}

locals {
  CodeDeploy = {
    sysname = "updating-containers-with-blue-green-deployments"
  }
}

locals {
  S3 = {
    sysname = "blue-green-deployments"
  }
}