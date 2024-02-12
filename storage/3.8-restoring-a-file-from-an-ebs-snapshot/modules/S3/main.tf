resource "aws_s3_bucket" "bucket" {
  bucket = "${var.bucket_name}"

  tags = {
    Name = "${var.sysname}-bucket"
  }
}

resource "aws_s3_bucket_ownership_controls" "ownership_control" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    object_ownership = var.object_ownership
  }
}

resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket = aws_s3_bucket.bucket.id
  acl = var.acl

  depends_on = [ aws_s3_bucket_ownership_controls.ownership_control ]
}

