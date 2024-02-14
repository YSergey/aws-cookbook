# IAM role for the Lambda function
resource "aws_iam_role" "lambda_role" {
  name = "lambda_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_vpc_access_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_access" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

#Lambda関数がVPC内のリソースにアクセスするためには、ネットワークインターフェイスを作成する権限が必要
resource "aws_iam_policy" "lambda_vpc_access_policy" {
  name = "lambda_vpc_access_policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
        ],
        Resource = "*",
        Effect = "Allow",
      },
    ],
  })
}

# IAM policy to allow the Lambda function to access the RDS database
# IAM policy to allow the Lambda function to access the RDS database via IAM authentication
resource "aws_iam_policy" "lambda_rds_connect" {
  name        = "LambdaRDSConnectPolicy"
  description = "Allow Lambda to generate IAM authentication tokens for RDS database access"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "rds-db:connect",
        Resource = "*"
      },
    ]
  })
}

# Attach the IAM policy to the Lambda role
resource "aws_iam_role_policy_attachment" "lambda_rds_connect_attach" {
  role       = aws_iam_role.lambda_role.id
  policy_arn = aws_iam_policy.lambda_rds_connect.arn
}
