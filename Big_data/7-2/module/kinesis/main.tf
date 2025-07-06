# Kinesisストリームの作成
resource "aws_kinesis_stream" "firehose_stream" {
  name        = "firehose-kinesis-stream"
  shard_count = 1
}

# Kinesis Data Firehose配信ストリームの作成
resource "aws_kinesis_firehose_delivery_stream" "firehose_stream" {
  name        = "firehose-delivery-stream"
  destination = "s3"

  kinesis_source_configuration {
    kinesis_stream_arn = aws_kinesis_stream.firehose_stream.arn
    role_arn           = aws_iam_role.firehose_role.arn
  }

  extended_s3_configuration {
    role_arn   = aws_iam_role.firehose_role.arn
    bucket_arn = var.bucket_arn
  }
}