data "aws_caller_identity" "current" {}

locals {
    db = {
        sysname = "creating-an-amazon-serveless-postgresql-database"
        cluster_identifier = "my-db-cluster"
        engine = "aurora-postgresql"
        engine_version = "13.12"
        database_name = "mydb"
        master_username = "clusteradmin"
        engine_mode = "serverless"

        auto_pause = true
        min_capacity = 8
        max_capacity = 16
        seconds_until_auto_pause = 300
    }
}

locals {
  VPC = {
    sysname = "creating-an-amazon-serveless-postgresql-database"
    vpc_cidr = "10.0.0.0/16"

    subnet_a_cidr = "10.0.1.0/24"
    subnet_b_cidr = "10.0.2.0/24"

    subnet_a_az = "us-west-2a"
    subnet_b_az = "us-west-2b"
  }
}

locals {
  IAM = {
    sysname = "creating-an-amazon-serveless-postgresql-database"
  }
}

locals {
  EC2_A = {
    sysname = "creating-an-amazon-serveless-postgresql-database-EC2-A"
    create_endpoint = true
    instance_type = "t2.micro"
    availability_zone = "us-west-2a"
  }
}


