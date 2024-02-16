data "aws_caller_identity" "current" {}

#これでマッチするエンジンバージョンを探す
#aws rds describe-db-engine-versions --engine aurora-mysql --query "DBEngineVersions[].EngineVersion"

locals {
    db = {
        sysname = "encrypting-storage-of-RDS"
        cluster_identifier = "my-db-cluster"
        engine = "aurora-mysql"
        engine_version = "5.7.mysql_aurora.2.07.9"
        database_name = "mydb"
        master_username = "clusteradmin"
        engine_mode = "provisioned"
        availability_zones = ["us-west-2a", "us-west-2b"]
        instance_class = "db.t3.small"
    }
}

locals {
  VPC = {
    sysname = "encrypting-storage-of-RDS"
    vpc_cidr = "10.0.0.0/16"

    subnet_public = "10.0.1.0/24"
    subnet_ec2_a_cidr = "10.0.2.0/24"
    subnet_ec2_b_cidr = "10.0.3.0/24"
    subnet_db_a_cidr = "10.0.4.0/24"
    subnet_db_b_cidr = "10.0.5.0/24"

    subnet_a_az = "us-west-2a"
    subnet_b_az = "us-west-2b"
  }
}


locals {
  EC2_A = {
    sysname = "encrypting-storage-of-RDS-EC2-A"
    create_endpoint = true
    instance_type = "t2.micro"
    availability_zone = "us-west-2a"
    accound_id = "${data.aws_caller_identity.current.account_id}"
  }
}


