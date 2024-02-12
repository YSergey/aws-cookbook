data "aws_caller_identity" "current" {}

locals {
    s3 = {
        sysname = "restoring-a-file-from-an-EBS-snapshot"
        bucket_name = "my-unique-bucket-name-for-aws-cookbook-3.8"
        object_ownership = "BucketOwnerPreferred"
        acl = "private"
    }
}

locals {
  VPC = {
    sysname = "restoring-a-file-from-an-EBS-snapshot"
    vpc_cidr = "10.0.0.0/16"

    subnet_a_cidr = "10.0.1.0/24"
    subnet_b_cidr = "10.0.2.0/24"

    subnet_a_az = "us-west-2a"
    subnet_b_az = "us-west-2b"
  }
}

locals {
  IAM = {
    sysname = "restoring-a-file-from-an-EBS-snapshot"
  }
}

locals {
  EC2_A = {
    sysname = "restoring-a-file-from-an-EBS-snapshot-EC2-A"
    create_endpoint = true
    create_snap_shot = true
    instance_type = "t2.micro"
    availability_zone = "us-west-2a"
  }
}

locals {
  EC2_B = {
    sysname = "restoring-a-file-from-an-EBS-snapshot-EC2-B"
    create_endpoint = false
    create_snap_shot = false
    instance_type = "t2.micro"
    availability_zone = "us-west-2b"
  }
}


