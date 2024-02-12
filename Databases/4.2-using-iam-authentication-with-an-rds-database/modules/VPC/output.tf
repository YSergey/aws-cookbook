output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr
}

output "subnet_ids" {
  value = [for s in module.subnet : s.subnet_id]
}

output "route_table_id" {
  value = [for route_table in module.route_table : route_table.route_table_id]
}