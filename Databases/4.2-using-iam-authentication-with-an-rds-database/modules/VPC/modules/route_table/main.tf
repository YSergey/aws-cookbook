resource "aws_route_table" "main" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.tag_name}"
  }
}

resource "aws_route_table_association" "route_table_association" {
  subnet_id      = var.subnet_id
  route_table_id = aws_route_table.main.id
}
