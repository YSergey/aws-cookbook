resource "aws_iam_policy" "kinesis_access" {
  name        = "KinesisAccessPolicy"
  description = "Policy for accessing AWSCookbook701 Kinesis stream"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kinesis:DescribeStreamSummary",
          "kinesis:PutRecord",
          "kinesis:GetShardIterator",
          "kinesis:GetRecords",
          "kinesis:ListShards"
        ]
        Resource = aws_kinesis_stream.example.arn
      }
    ]
  })
}