output "vpc_id" {
  value = aws_vpc.main.id 
}

output "vpc_cidr" {
  value = aws_vpc.main.cidr_block
}

output "subnet_ec2_a_id" {
  value = aws_subnet.subnet_ec2_a.id
}

output "subnet_ec2_b_id" {
  value = aws_subnet.subnet_ec2_b.id
}

output "subnet_db_a_id" {
  value = aws_subnet.subnet_db_a.id
}

output "subnet_db_b_id" {
  value = aws_subnet.subnet_db_b.id
}

output "ec2_a_route_table_id" {
  value = aws_route_table.ec2_a.id
}

output "ec2_b_route_table_id" {
  value = aws_route_table.ec2_b.id
}

output "db_a_route_table_id" {
  value = aws_route_table.db_a.id
}

output "db_b_route_table_id" {
  value = aws_route_table.db_b.id
}