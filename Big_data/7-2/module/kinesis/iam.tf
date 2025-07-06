# Firehoseが引き受けるIAMロールの作成
resource "aws_iam_role" "firehose_role" {
  name = "firehose-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      }
    ]
  })
}

# Firehose用のIAMポリシー
resource "aws_iam_role_policy" "firehose_policy" {
  name   = "firehose-policy"
  role   = aws_iam_role.firehose_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:GetBucketLocation"
        ]
        Resource = "${var.bucket_arn}"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:AbortMultipartUpload",
          "s3:GetObject"
        ]
        Resource = "${aws_s3_bucket.firehose_bucket.arn}/*"
      },
      {
        Effect = "Allow"
        Action = [
          "kinesis:DescribeStream",
          "kinesis:GetShardIterator",
          "kinesis:GetRecords",
          "kinesis:ListShards"
        ]
        Resource = "${aws_kinesis_stream.firehose_stream.arn}"
      }
    ]
  })
}