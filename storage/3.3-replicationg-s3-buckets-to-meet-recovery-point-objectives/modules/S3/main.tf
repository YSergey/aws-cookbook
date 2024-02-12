resource "aws_s3_bucket" "source_bucket" {
  bucket = "source-${var.bucket_name}"

  tags = {
    Name = "${var.sysname}-source-bucket"
  }
}

resource "aws_s3_bucket" "destination_bucket" {
  bucket = "destination-${var.bucket_name}"

  tags = {
    Name = "${var.sysname}-destination-bucket"
  }
}

resource "aws_s3_bucket_ownership_controls" "source_ownership_control" {
  bucket = aws_s3_bucket.source_bucket.id

  rule {
    object_ownership = var.object_ownership
  }
}

resource "aws_s3_bucket_ownership_controls" "destination_ownership_control" {
  bucket = aws_s3_bucket.destination_bucket.id

  rule {
    object_ownership = var.object_ownership
  }
}

resource "aws_s3_bucket_acl" "s3_source_bucket_acl" {
  bucket = aws_s3_bucket.source_bucket.id
  acl = var.acl

  depends_on = [ aws_s3_bucket_ownership_controls.source_ownership_control ]
}

resource "aws_s3_bucket_acl" "s3_destination_bucket_acl" {
  bucket = aws_s3_bucket.destination_bucket.id
  acl = var.acl

  depends_on = [ aws_s3_bucket_ownership_controls.destination_ownership_control ]
}

resource "aws_s3_bucket_versioning" "source" {
  bucket = aws_s3_bucket.source_bucket.id
  
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_versioning" "destination" {
  bucket = aws_s3_bucket.destination_bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_replication_configuration" "replication" {
  depends_on = [aws_s3_bucket_versioning.source]

  role   = var.replication_arn
  bucket = aws_s3_bucket.source_bucket.id

  rule {
    id = "foobar"
    priority = 1
    status = "Enabled"

    filter {
      prefix = ""
    }

    delete_marker_replication {
      status = "Disabled"
    }

    destination {
      bucket        = aws_s3_bucket.destination_bucket.arn
      storage_class = "STANDARD"

      metrics {
        status = "Enabled"
        event_threshold {
          minutes = 15
        }
      }

      replication_time {
        status = "Enabled"
        time {
          minutes = 15
        }
      }
    }
  }
}