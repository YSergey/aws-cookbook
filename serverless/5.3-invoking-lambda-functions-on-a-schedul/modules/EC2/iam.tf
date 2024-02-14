resource "aws_iam_role" "instance" {
  name               = "ssm-instance"
  path               = "/"
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

# IAMロールにマネージドポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_policy" "rds_proxy_access" {
  name        = "RDSProxyAccessPolicy"
  description = "Policy that allows describe RDS Proxy Targets"
  policy      = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "rds:DescribeDBProxyTargets",
          "rds:DescribeDBProxies",
          "rds-db:connect"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "rds_proxy_access" {
  role       = aws_iam_role.instance.name
  policy_arn = aws_iam_policy.rds_proxy_access.arn
}



# 作成した IAM ロールを割り当てた IAM インスタンスプロファイル
resource "aws_iam_instance_profile" "instance" {
  name = "${var.sysname}-instance"
  role = aws_iam_role.instance.name

  depends_on = [ 
    aws_iam_role.instance
  ]
}