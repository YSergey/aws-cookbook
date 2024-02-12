resource "aws_subnet" "subnet" {
  vpc_id     = var.vpc_id
  cidr_block = var.subnet_cidr
  availability_zone = var.az
  map_public_ip_on_launch = var.map_public_on_launch

  tags = {
    Name = "${var.tag_name}"
  }
}