output "bucket_id" {
    value = aws_s3_bucket.data_bucket.id
}

output "results_bucket_arn" {
    value = aws_s3_bucket.results_bucket.arn
}