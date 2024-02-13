data "aws_caller_identity" "current" {}

#これでマッチするエンジンバージョンを探す
#aws rds describe-db-engine-versions --engine aurora-mysql --query "DBEngineVersions[].EngineVersion"

locals {
    db = {
        sysname = "leveraging-rds-proxy-for-database-connections-from-lambda"
        availability_zones = ["us-west-2a", "us-west-2b"]

        cluster_identifier = "my-db-cluster"
        # engine = "aurora-mysql"
        engine = "mysql"
        engine_mode = "provisioned"
        # engine_version = "8.0.mysql_aurora.3.04.1"
        engine_version = "8.0"
        instance_class = "db.t3.medium"
        database_name = "mydb"
        master_username = "clusteradmin"
    }
}

locals {
  VPC = {
    sysname = "leveraging-rds-proxy-for-database-connections-from-lambda"
    vpc_cidr = "10.0.0.0/16"

    subnet_public_cidr = "10.0.1.0/24"
    subnet_ec2_a_cidr = "10.0.2.0/24"
    subnet_ec2_b_cidr = "10.0.3.0/24"
    subnet_db_a_cidr = "10.0.4.0/24"
    subnet_db_b_cidr = "10.0.5.0/24"

    subnet_a_az = "us-west-2a"
    subnet_b_az = "us-west-2b"
  }
}

locals {
  Lambda = {
    sysname = "leveraging-rds-proxy-for-database-connections-from-lambda"
    file_name = "modules/Lambda/lambda_function.zip"
    function_name = "lambda_function"
    handler = "lambda_function.lambda_handler"
    runtime = "python3.10"
  }
}

locals {
  EC2_A = {
    sysname = "leveraging-rds-proxy-for-database-connections-from-lambda-EC2-A"
    instance_type = "t2.micro"
    availability_zone = "us-west-2a"
  }
}


