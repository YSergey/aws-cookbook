output "source_code_s3_key" {
  value = aws_s3_object.object.key
  description = "The key/path for the uploaded ZIP file in the source code S3 bucket."
}

output "source_code_object_version_id" {
    value = aws_s3_object.object.version_id
}