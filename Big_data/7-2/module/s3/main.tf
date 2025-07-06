# S3バケットの作成
resource "aws_s3_bucket" "firehose_bucket" {
  bucket = "firehose-s3-bucket-${random_string.bucket_suffix.result}"
}

# バケット名のユニーク性を確保するためのランダム文字列
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}
