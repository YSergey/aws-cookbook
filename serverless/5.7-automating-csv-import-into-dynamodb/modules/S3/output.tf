

output "s3_arn" {
    value = aws_s3_bucket.example.arn
}

# output "s3_key" {
#     value = aws_s3_object.s3_object.key
# }