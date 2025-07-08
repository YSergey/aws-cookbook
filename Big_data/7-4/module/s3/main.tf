# S3バケットの作成
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "aws_s3_bucket" "data_bucket" {
  bucket = "awscookbook704-data-${random_string.bucket_suffix.result}"
}

# 2. S3バケットの作成（Athenaクエリ結果用）
resource "aws_s3_bucket" "results_bucket" {
  bucket = "awscookbook704-results-${random_string.bucket_suffix.result}"
}


resource "aws_s3_bucket_public_access_block" "data_bucket_private" {
  bucket = aws_s3_bucket.data_bucket.id 
  block_public_acls = true 
  block_public_policy = true 
  ignore_public_acls = true 
  restrict_public_buckets = true
}


resource "aws_s3_bucket_public_access_block" "results_bucket_private" {
  bucket = aws_s3_bucket.results_bucket.id 
  block_public_acls = true 
  block_public_policy = true 
  ignore_public_acls = true 
  restrict_public_buckets = true
}
