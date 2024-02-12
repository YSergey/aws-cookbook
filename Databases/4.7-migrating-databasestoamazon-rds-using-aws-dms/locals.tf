data "aws_caller_identity" "current" {}

#これでマッチするエンジンバージョンを探す
#aws rds describe-db-engine-versions --engine aurora-mysql --query "DBEngineVersions[].EngineVersion"

locals {
    db = {
        sysname = "migrating-database-to-RDS-using-DMS"
        cluster_identifier = "my-db-cluster"
        db_password = "kobutaman1"
        engine = "aurora-mysql"
        engine_version = "5.7.mysql_aurora.2.07.9"
        database_name = "mydb"
        master_username = "clusteradmin"
        engine_mode = "serverless"
        availability_zones = ["us-west-2a", "us-west-2b"]

        instance_class = "db.t3.small"

        source_db_identifier = "database-cluster-source-instance"
        target_db_identifier = "database-cluster-target-instance"
    }
}

locals {
    dms = {
        sysname = "migrating-database-to-RDS-using-DMS"
        db_password = "kobutaman1"
        instance_class = "dms.t3.small"
    }
}

locals {
  VPC = {
    sysname = "migrating-database-to-RDS-using-DMS"
    vpc_cidr = "10.0.0.0/16"

    subnet_a_cidr = "10.0.1.0/24"
    subnet_b_cidr = "10.0.2.0/24"

    subnet_a_az = "us-west-2a"
    subnet_b_az = "us-west-2b"
  }
}

locals {
  IAM = {
    sysname = "migrating-database-to-RDS-using-DMS"
  }
}

locals {
  EC2_A = {
    sysname = "migrating-database-to-RDS-using-DMS-EC2-A"
    create_endpoint = true
    instance_type = "t2.micro"
    availability_zone = "us-west-2a"
  }
}


