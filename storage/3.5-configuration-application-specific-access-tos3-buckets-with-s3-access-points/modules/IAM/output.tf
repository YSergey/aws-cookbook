output "aws_iam_role_arn" {
    value = aws_iam_role.instance.arn
}

output "instance_profile" {
  value = aws_iam_instance_profile.instance.name
}