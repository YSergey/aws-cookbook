output "image_uri" {
  value = "${aws_ecr_repository.lambda_repository.repository_url}:latest"
}