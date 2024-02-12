output "tg_bucket_name" {
    value = "${var.sysname}-s3-target"
}

output "bucket_arn" {
    value = aws_s3_bucket.target_bucket.arn
}