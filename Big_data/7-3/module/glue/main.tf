# Glueデータベースの作成
resource "aws_glue_catalog_database" "database" {
  name = "awscookbook703"
}

# Glue Crawlerの作成
resource "aws_glue_crawler" "crawler" {
  database_name = aws_glue_catalog_database.database.name
  name          = "awscookbook703-crawler"
  role          = aws_iam_role.glue_role.arn

  s3_target {
    path = "s3://${var.bucket_name}/data/"
  }
}

# Glueデータベースの作成
resource "aws_glue_catalog_database" "database" {
  name = "awscookbook703"
}

# Glue Crawlerの作成
resource "aws_glue_crawler" "crawler" {
  database_name = aws_glue_catalog_database.database.name
  name          = "awscookbook703-crawler"
  role          = aws_iam_role.glue_role.arn

  s3_target {
    path = "s3://${var.bucket_name}/data/"
  }
}