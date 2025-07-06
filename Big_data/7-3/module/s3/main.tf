# S3バケットの作成
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket" "data_bucket" {
  bucket = "awscookbook703-data-${random_string.bucket_suffix.result}"
}