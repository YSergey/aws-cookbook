output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_1" {
  value = aws_subnet.public_subnet_1.id
}

output "public_subnet_2" {
  value = aws_subnet.public_subnet_2.id
}

output "isolated_subnet_1" {
  value = aws_subnet.isolated_subnet_1.id
}

output "isolated_subnet_2" {
  value = aws_subnet.isolated_subnet_2.id
}

output "isolated_route_table_id" {
  value = aws_route_table.isolated_route_table_1.id
}

output "public_route_table_id" {
  value = aws_route_table.public_route_table_1.id
}