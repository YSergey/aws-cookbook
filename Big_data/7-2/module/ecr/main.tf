resource "aws_ecr_repository" "lambda_repo" {
  name = "lambda-kinesis-processor"
}

resource "null_resource" "build_and_push" {
  provisioner "local-exec" {
    command = <<EOT
      aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${aws_ecr_repository.lambda_repo.repository_url}
      docker build -t ${aws_ecr_repository.lambda_repo.repository_url}:latest .
      docker push ${aws_ecr_repository.lambda_repo.repository_url}:latest
    EOT
  }
  depends_on = [aws_ecr_repository.lambda_repo]
}