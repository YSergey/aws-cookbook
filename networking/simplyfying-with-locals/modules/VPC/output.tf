output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "public_subnet_1_1" {
  value = aws_subnet.public-subnet-1-1.id
}

output "public_subnet_1_2" {
  value = aws_subnet.public-subnet-1-2.id
}

output "isolated_subnet_1_1" {
  value = aws_subnet.isolated-subnet-1-1.id
}

output "isolated_subnet_1_2" {
  value = aws_subnet.isolated-subnet-1-2.id
}