data "aws_caller_identity" "current" {}

#これでマッチするエンジンバージョンを探す
#aws rds describe-db-engine-versions --engine aurora-mysql --query "DBEngineVersions[].EngineVersion"

locals {
    db = {
        sysname = "autoscaling-dynamodb-table-provisioned-capacity"
        table_name = "autoscaling-dynamodb-table"
    }
}