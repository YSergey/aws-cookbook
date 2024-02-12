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

resource "aws_s3_bucket_policy" "my_bucket_policy" {
  bucket = aws_s3_bucket.bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Id      = "EnforceKMSEncryption",
    Statement = [
      {
        Sid       = "RequireKMSEncryption",
        Effect    = "Deny",
        Principal = "*",
        Action    = "s3:PutObject",
        Resource  = "${aws_s3_bucket.bucket.arn}/*",
        Condition = {
          StringNotEquals = {
            "s3:x-amz-server-side-encryption-aws-kms-key-id" = "${var.my_kms_key_id}"
          }
        }
      }
    ]
  })
}