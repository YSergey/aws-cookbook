output "aws_iam_arn" {
  value = aws_iam_role.instance.arn
}

output "aws_iam_instance_profile" {
  value = aws_iam_instance_profile.instance.name
}

output "rds_proxy_role_arn" {
  value = aws_iam_policy.lambda_rds_connect.arn
}

output "iam_rds_proxy_role" {
  value = aws_iam_role.rds_proxy_role.arn
}