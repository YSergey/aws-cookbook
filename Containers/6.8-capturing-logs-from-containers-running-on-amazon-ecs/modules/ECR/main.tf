resource "aws_ecr_repository" "docker_repository" {
  name                 = "${var.sysname}-container-repo" # Name your repository
  image_tag_mutability = "MUTABLE"
}
