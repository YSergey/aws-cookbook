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

data "aws_caller_identity" "current" {}

resource "aws_s3control_storage_lens_configuration" "example" {
  config_id = "example-1"

  storage_lens_configuration {
    enabled = true

    account_level {
      activity_metrics {
        enabled = true
      }

      bucket_level {
        activity_metrics {
          enabled = true
        }
      }
    }

    data_export {
      cloud_watch_metrics {
        enabled = true
      }
    }
  }
}