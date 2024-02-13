resource "aws_iam_role" "rds_proxy_role" {
  name = "RDSPROXYIAMRole"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = "sts:AssumeRole",
        Principal = {
          Service : "rds.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "RDSPROXYIAMRole"
  }
}


# RDS ProxyがSecrets Managerからシークレットを取得するためのポリシー
resource "aws_iam_policy" "rds_proxy_secrets_policy" {
  name        = "RDSSecretsAccessPolicy"
  description = "Allow RDS Proxy to access secrets in Secrets Manager"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetResourcePolicy", 
          "secretsmanager:GetSecretValue", 
          "secretsmanager:DescribeSecret", 
          "secretsmanager:ListSecretVersionIds" 
        ],
        Resource = "${aws_secretsmanager_secret.db_secret.arn}"
      }
    ]
  })

  depends_on = [ aws_secretsmanager_secret.db_secret ]
}

# RDS Proxyのロールにシークレットアクセスポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "rds_proxy_secrets_attach" {
  role       = aws_iam_role.rds_proxy_role.id
  policy_arn = aws_iam_policy.rds_proxy_secrets_policy.arn
}

# CloudWatch Logsへの書き込み権限を持つポリシー
resource "aws_iam_policy" "rds_proxy_cloudwatch_logs_policy" {
  name        = "RDSProxyCloudWatchLogsAccessPolicy"
  description = "Allow RDS Proxy to write logs to CloudWatch Logs"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:CreateLogGroup"
        ],
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

# RDS ProxyのロールにCloudWatch Logsアクセスポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "rds_proxy_cloudwatch_logs_attach" {
  role       = aws_iam_role.rds_proxy_role.id
  policy_arn = aws_iam_policy.rds_proxy_cloudwatch_logs_policy.arn
}

