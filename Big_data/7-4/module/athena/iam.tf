# 3. IAMロールの作成（Athena用）
data "aws_iam_policy_document" "athena_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["athena.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "athena_role" {
  name               = "athena-execution-role"
  assume_role_policy = data.aws_iam_policy_document.athena_assume_role.json
}

# 3.1. S3アクセス用ポリシー（データバケット読み取り）
data "aws_iam_policy_document" "s3_read_data" {
  statement {
    actions   = ["s3:GetObject", "s3:ListBucket"]
    resources = [
      aws_s3_bucket.data_bucket.arn,
      "${aws_s3_bucket.data_bucket.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "s3_read_data_policy" {
  name   = "athena-s3-read-data"
  policy = data.aws_iam_policy_document.s3_read_data.json
}

# 3.2. S3アクセス用ポリシー（結果バケット書き込み）
data "aws_iam_policy_document" "s3_write_results" {
  statement {
    actions   = ["s3:PutObject", "s3:GetObject", "s3:ListBucket"]
    resources = [
      aws_s3_bucket.results_bucket.arn,
      "${aws_s3_bucket.results_bucket.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "athena_execution_policy" {
  name = "athena-execution-policy"

  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        # Snowflakeのログが保存されているS3バケットへの読み取り権限
        Effect   = "Allow",
        Action   = ["s3:GetObject", "s3:ListBucket"],
        Resource = [
          aws_s3_bucket.log_archive.arn,
          "${aws_s3_bucket.log_archive.arn}/*"
        ]
      },
      {
        # Athenaのクエリ結果バケットへの書き込み権限
        Effect   = "Allow",
        Action   = ["s3:GetObject", "s3:ListBucket", "s3:PutObject"],
        Resource = [
          aws_s3_bucket.athena_results.arn,
          "${aws_s3_bucket.athena_results.arn}/*"
        ]
      },
      {
        # Glueデータカタログへのアクセス権限
        Effect = "Allow",
        Action = [
          "glue:GetDatabase",
          "glue:GetDatabases",
          "glue:GetTable",
          "glue:GetTables",
          "glue:GetPartition",
          "glue:GetPartitions",
          "glue:BatchGetPartition"
        ],
        Resource = ["*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "athena_execution_policy_attachment" {
  role       = aws_iam_role.athena_execution_role.name
  policy_arn = aws_iam_policy.athena_execution_policy.arn
}

resource "aws_iam_policy" "s3_write_results_policy" {
  name   = "athena-s3-write-results"
  policy = data.aws_iam_policy_document.s3_write_results.json
}

# 3.3. ポリシーのIAMロールへのアタッチ
resource "aws_iam_role_policy_attachment" "athena_s3_read" {
  role       = aws_iam_role.athena_role.name
  policy_arn = aws_iam_policy.s3_read_data_policy.arn
}

resource "aws_iam_role_policy_attachment" "athena_s3_write" {
  role       = aws_iam_role.athena_role.name
  policy_arn = aws_iam_policy.s3_write_results_policy.arn
}