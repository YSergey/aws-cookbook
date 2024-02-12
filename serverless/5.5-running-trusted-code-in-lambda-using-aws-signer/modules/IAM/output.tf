output "lambda_role_arn" {
  value = aws_iam_role.lambda_execution_role.arn
}

output "aws_iam_arn" {
  value = aws_iam_role.instance.arn
}

output "aws_iam_instance_profile" {
  value = aws_iam_instance_profile.instance.name
}