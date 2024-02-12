locals {
  VPC = {
    sysname = "building-and-tagging-and-pushing-a-container-image-to-amazon-ecr"
    vpc_cidr = "10.0.0.0/16"

    subnet_a_cidr = "10.0.1.0/24"
    subnet_b_cidr = "10.0.2.0/24"

    subnet_a_az = "us-west-2a"
    subnet_b_az = "us-west-2b"
  }
}

locals {
  ECR = {
    sysname = "building-and-tagging-and-pushing-a-container-image-to-amazon-ecr"
  }
}