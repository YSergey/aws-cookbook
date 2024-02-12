resource "aws_s3_bucket" "example" {
  bucket = "${var.sysname}-bucket"
}

#自動でアップロードしたいときは以下のリソースを使用
# resource "aws_s3_object" "s3_object" {
#   bucket = aws_s3_bucket.example.id
#   key    = var.object_key
#   source = var.source_path
#   etag   = filemd5(var.source_path)
# }


resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.example.id

  lambda_function {
    lambda_function_arn = var.lambda_arn
    events             = ["s3:ObjectCreated:*"]
    filter_prefix      = "sample_data.csv" // Update or remove this based on your requirements
  }
}
