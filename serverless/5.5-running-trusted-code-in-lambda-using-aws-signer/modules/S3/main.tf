resource "aws_s3_bucket" "source_code" {
  bucket = var.source_code_bucket

  tags = {
    Name = "${var.sysname}-source-code"
  }
}

resource "aws_s3_bucket_ownership_controls" "source_ownership_control" {
  bucket = aws_s3_bucket.source_code.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}


resource "aws_s3_bucket_acl" "example" {
  bucket = aws_s3_bucket.source_code.id
  acl    = "private"

  depends_on = [ aws_s3_bucket_ownership_controls.source_ownership_control ]
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.source_code.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.source_code.id
  key    = var.object_key
  source = var.source_path
  
  depends_on = [aws_s3_bucket_versioning.versioning_example]
}


resource "aws_s3_bucket" "signed_code" {
  bucket = var.signed_code_bucket

  tags = {
    Name = "${var.sysname}-signed-code"
  }
}
