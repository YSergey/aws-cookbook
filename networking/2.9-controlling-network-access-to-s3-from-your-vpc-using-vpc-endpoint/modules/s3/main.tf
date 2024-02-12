# S3 bucket creation
resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-name-for-test"
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.my_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.my_bucket.id
  acl    = "private"

  depends_on = [aws_s3_bucket_ownership_controls.example]
}