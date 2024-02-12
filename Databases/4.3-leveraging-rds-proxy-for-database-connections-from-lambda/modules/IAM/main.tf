
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

# AmazonSSMManagedInstanceCore の情報を取得
data "aws_iam_policy" "ssm_core" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAMロールにマネージドポリシーをアタッチ
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.instance.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

#RDSのポリシーとIAMを用意
# resource "aws_iam_policy" "rds_iam_auth" {
#   name        = "RDSIAMAuthentication"
#   description = "Allows EC2 instance to authenticate with RDS using IAM"
#   policy      = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#       {
#         "Effect": "Allow",
#         "Action": "rds-db:connect",
#         "Resource": "arn:aws:rds-db:${var.region}:${var.aws_account_id}:dbuser:${var.rds_proxy_endpoint}/IAM_USER"
#       }
#     ]
#   })
# }

# IAM Role for RDS Proxy 
resource "aws_iam_role" "rds_proxy_role" {
  name = "RDSPROXYIAMRole"
  
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service" : "rds.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_rds_connect" {
  name        = "LambdaRDSConnectPolicy"
  description = "Allow Lambda to generate IAM authentication tokens"
  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "rds-db:connect",
        "Resource": "arn:aws:rds-db:${var.region}:${var.aws_account_id}:dbuser:${var.rds_proxy_endpoint}/IAM_USER"
      }
    ]
  })
}

# IAM ロールにポリシーを付与
resource "aws_iam_role_policy_attachment" "lambda_rds_connect_attach" {
  policy_arn = aws_iam_policy.lambda_rds_connect.arn
  role       = aws_iam_role.rds_proxy_role.name
}


# IAM ロールにポリシーを付与
resource "aws_iam_role_policy" "instance" {
  name   = "${var.sysname}-instance"
  role   =  aws_iam_role.instance.id 
  policy = data.aws_iam_policy.ssm_core.policy
}

# resource "aws_iam_role_policy_attachment" "attach_ec2" {
#   policy_arn = aws_iam_policy.lambda_rds_connect.arn
#   role       = aws_iam_role.instance.name  # Assuming you have defined this role
# }

# 作成した IAM ロールを割り当てた IAM インスタンスプロファイル
resource "aws_iam_instance_profile" "instance" {
  name = "${var.sysname}-instance"
  role = aws_iam_role.instance.name

  depends_on = [ 
    aws_iam_role_policy.instance
  ]
}