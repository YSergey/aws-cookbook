resource "aws_iam_role" "instance" {
  name               = "${var.sysname}-instance"
  path               = "/"
  assume_role_policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  })
}

# AmazonSSMManagedInstanceCore の情報を取得
data "aws_iam_policy" "ssm_core" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAM ロールにポリシーを付与
resource "aws_iam_role_policy" "instance_ssm" {
  name   = "${var.sysname}-instance-ssm"
  role   = aws_iam_role.instance.id
  policy = data.aws_iam_policy.ssm_core.policy
}

# 作成した IAM ロールを割り当てた IAM インスタンスプロファイル
resource "aws_iam_instance_profile" "instance" {
  name = "${var.sysname}-instance"
  role = aws_iam_role.instance.name

  depends_on = [ 
    aws_iam_role_policy.instance_ssm
  ]
}

