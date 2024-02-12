output "efs_arn" {
    value = aws_efs_file_system.my_efs.arn
}

output "efs_access_point_arn" {
    value = aws_efs_access_point.my_access_point.arn
}

output "efs_sg_id" {
    value = aws_security_group.efs_sg.id
}