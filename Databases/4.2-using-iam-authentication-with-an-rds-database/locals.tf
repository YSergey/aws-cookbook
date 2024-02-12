data "aws_caller_identity" "current" {}

#これでマッチするエンジンバージョンを探す
#aws rds describe-db-engine-versions --engine aurora-mysql --query "DBEngineVersions[].EngineVersion"

locals {
    db = {
        sysname = "using-iam-authentication-with-an-rds-database"
        cluster_identifier = "my-db-cluster"
        engine = "aurora-mysql"
        engine_version = "5.7.mysql_aurora.2.07.9"
        database_name = "mydb"
        master_username = "clusteradmin"
        engine_mode = "serverless"
        availability_zones = ["us-west-2a", "us-west-2b"]

        instance_class = "db.t3.small"
    }
}

locals {
  VPC = {
    sysname = "using-iam-authentication-with-an-rds-database"
    vpc_cidr = "10.0.0.0/16"

    subnets = [
    {
      cidr = "10.0.1.0/24",
      az = "us-west-2a",
      map_public_ip_on_launch = true
      subnet_name = "Public-Subnet"
    },
    {
      cidr = "10.0.2.0/24",
      az = "us-west-2a",
      map_public_ip_on_launch = false
      subnet_name = "Subnet-EC2-A"
    },
    {
      cidr = "10.0.3.0/24",
      az = "us-west-2b",
      map_public_ip_on_launch = false
      subnet_name = "Subnet-EC2-B"
    },
    {
      cidr = "10.0.4.0/24",
      az = "us-west-2a",
      map_public_ip_on_launch = false
      subnet_name = "Subnet-DB-A"
    },
    {
      cidr = "10.0.5.0/24",
      az = "us-west-2b",
      map_public_ip_on_launch = false
      subnet_name = "Subnet-DB-B"
    },
    ],

    route_table = [
      {
        table_name = "route-table-public"
      },
      {
        table_name = "route-table-EC2-A"
      },
      {
        table_name = "route-table-EC2-B"
      },
      {
        table_name = "route-table-DB-A"
      },
      {
        table_name = "route-table-DB-B"
      },
      
    ]
  }
}

locals {
  IAM = {
    sysname = "using-iam-authentication-with-an-rds-database"
  }
}

locals {
  EC2_A = {
    sysname = "using-iam-authentication-with-an-rds-database-EC2-A"
    instance_type = "t2.micro"
    availability_zone = "us-west-2a"
    account_id = "#####"
  }
}


