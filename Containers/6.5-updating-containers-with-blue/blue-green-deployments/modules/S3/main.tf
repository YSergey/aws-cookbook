resource "aws_s3_bucket" "codedeploy_bucket" {
  bucket = "${var.sysname}-codedeploy-bucket"
}

resource "aws_s3_object" "appspec" {
  bucket = aws_s3_bucket.codedeploy_bucket.id
  key    = "appspec.yaml"
  content = var.appspec
  content_type = "text/yaml"
}
