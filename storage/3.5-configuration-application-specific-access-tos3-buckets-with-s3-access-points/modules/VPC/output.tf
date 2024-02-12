output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "subnet_a_id" {
  value = aws_subnet.subnet_a.id
}

output "subnet_b_id" {
  value = aws_subnet.subnet_b.id
}

output "subnet_a_az" {
  value = var.subnet_a_az
}

output "subnet_b_az" {
  value = var.subnet_b_az
}