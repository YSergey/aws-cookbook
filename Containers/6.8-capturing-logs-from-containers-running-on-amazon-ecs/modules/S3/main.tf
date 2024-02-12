# Define the S3 Bucket
resource "aws_s3_bucket" "target_bucket" {
  bucket = "${var.sysname}-s3-target"
}

# resource "aws_s3_object" "input_folder" {
#   bucket = aws_s3_bucket.target_bucket.id
#   key    = "input-file/"
# }

# Enable EventBridge Notifications for the S3 Bucket
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.target_bucket.id
  eventbridge = true
}