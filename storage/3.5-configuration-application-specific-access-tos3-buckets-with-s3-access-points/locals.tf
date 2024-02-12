data "aws_caller_identity" "current" {}

locals {
  IAM = {
    sysname = "configuration-application-s3-access-point"
  }
}

locals {
    s3 = {
        sysname = "configuration-application-specific-access-to-s3-buckets-with-s3-access-point"
        bucket_name = "my-unique-bucket-name-for-aws-cookbook-3.5"
        object_ownership = "BucketOwnerPreferred"
        acl = "private"
    }
}

locals {
    S3_access_point_A = {
        sysname = "access-point-a"
    }
}

locals {
    S3_access_point_B = {
        sysname = "access-point-b"
    }
}

locals {
    vpc = {
        sysname = "configuration-application-specific-access-to-s3-buckets-with-s3-access-point"
        vpc_cidr_block = "10.0.0.0/16"

        subnet_a_cidr_block = "10.0.1.0/24"
        subnet_b_cidr_block = "10.0.2.0/24"

        subnet_a_az = "us-west-2a"
        subnet_b_az = "us-west-2b"
    }
}

locals {
    EC2_A = {
        sysname = "configuration-application-specific-access-to-s3-buckets-with-s3-access-point-EC2-A"
        security_group_name = "EC2-A-security-group"
        instance_name = "EC2-A"
        instance_type = "t2.micro"
        create_ssm_endpoint = true
    }
}

locals {
    EC2_B = {
        sysname = "configuration-application-specific-access-to-s3-buckets-with-s3-access-point-EC2-B"
        security_group_name = "EC2-B-security-group"
        instance_name = "EC2-B"
        instance_type = "t2.micro"
        create_ssm_endpoint = false
    }
}