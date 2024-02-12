resource "aws_iam_role" "instance" {
  name               = "instance"
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

# AmazonS3FullAccess の情報を取得
data "aws_iam_policy" "s3_full_access" {
  arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

# IAM ロールにポリシーを付与
resource "aws_iam_role_policy" "instance_ssm" {
  name   = "instance_ssm"
  role   = aws_iam_role.instance.id
  policy = data.aws_iam_policy.ssm_core.policy
}

# # Attach AmazonS3FullAccess policy to IAM Role
resource "aws_iam_role_policy" "s3_full_access_policy_attachment" {
  name = "instance_s3_full_access"
  role       = aws_iam_role.instance.id
  policy = data.aws_iam_policy.s3_full_access.policy
}

# 作成した IAM ロールを割り当てた IAM インスタンスプロファイル
resource "aws_iam_instance_profile" "instance" {
  name = "instance"
  role = aws_iam_role.instance.name

  depends_on = [ 
    aws_iam_role_policy.instance_ssm,
    aws_iam_role_policy.s3_full_access_policy_attachment
  ]
}

