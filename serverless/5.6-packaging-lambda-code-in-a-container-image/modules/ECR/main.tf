resource "aws_ecr_repository" "lambda_repository" {
  name                 = "${var.sysname}-container-repo" # Name your repository
  image_tag_mutability = "MUTABLE"
}
