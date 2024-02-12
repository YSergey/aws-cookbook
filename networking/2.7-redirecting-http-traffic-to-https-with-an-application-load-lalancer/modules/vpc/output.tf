output "aws_vpc_id" {
    value = aws_vpc.main.id
}

output "aws_public_subnet_1" {
    value = aws_subnet.public_1.id
}

output "aws_public_subnet_2" {
    value = aws_subnet.public_2.id
}