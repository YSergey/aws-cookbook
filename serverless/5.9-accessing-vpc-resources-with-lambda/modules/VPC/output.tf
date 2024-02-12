output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_a_id" {
  value = aws_subnet.subnet_a.id
}

output "subnet_b_id" {
  value = aws_subnet.subnet_b.id
}

output "subnet_a_cidr" {
  value = aws_subnet.subnet_a.cidr_block
}

output "subnet_b_cidr" {
  value = aws_subnet.subnet_b.cidr_block
}
