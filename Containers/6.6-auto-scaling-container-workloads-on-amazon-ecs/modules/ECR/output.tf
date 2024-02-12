output "image_uri" {
  value = "${aws_ecr_repository.docker_repository.repository_url}:latest"
}