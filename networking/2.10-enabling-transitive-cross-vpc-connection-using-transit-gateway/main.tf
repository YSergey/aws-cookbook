
module "iam1" {
  source = "./modules/iam"
  sysname = local.iam1.sysname
}

module "iam2" {
  source = "./modules/iam"
  sysname = local.iam2.sysname
}

module "iam3" {
  source = "./modules/iam"
  sysname = local.iam3.sysname
}

module "vpc1" {
  source = "./modules/VPC"

  sysname = local.vpc1.sysname
  cidr_block = local.vpc1.vpc_cidr

  public_subnet_1_cidr = local.vpc1.public_subnet_1_1_cidr
  isolated_subnet_1_cidr = local.vpc1.isolated_subnet_1_1_cidr
  public_subnet_2_cidr = local.vpc1.public_subnet_1_2_cidr
  isolated_subnet_2_cidr = local.vpc1.isolated_subnet_1_2_cidr

  create_igw = local.vpc1.create_igw
  route_transit_gateway = local.vpc1.route_transit_gateway
  transit_gateway_id = module.TGW.transit_gateway_id

  availability_zone_1 = local.vpc1.availability_zone_1
  availability_zone_2 = local.vpc1.availability_zone_2
}

module "vpc2" {
  source = "./modules/VPC"

  sysname = local.vpc2.sysname
  cidr_block = local.vpc2.vpc_cidr

  public_subnet_1_cidr = local.vpc2.public_subnet_2_1_cidr 
  isolated_subnet_1_cidr = local.vpc2.isolated_subnet_2_1_cidr
  public_subnet_2_cidr = local.vpc2.public_subnet_2_2_cidr
  isolated_subnet_2_cidr = local.vpc2.isolated_subnet_2_2_cidr

  create_igw = local.vpc2.create_igw
  route_transit_gateway = local.vpc2.route_transit_gateway
  transit_gateway_id = module.TGW.transit_gateway_id
  
  availability_zone_1 = local.vpc2.availability_zone_1
  availability_zone_2 = local.vpc2.availability_zone_2
}

module "vpc3" {
  source = "./modules/VPC"

  sysname = local.vpc3.sysname
  cidr_block = local.vpc3.vpc_cidr

  public_subnet_1_cidr = local.vpc3.public_subnet_3_1_cidr
  isolated_subnet_1_cidr = local.vpc3.isolated_subnet_3_1_cidr
  public_subnet_2_cidr = local.vpc3.public_subnet_3_2_cidr
  isolated_subnet_2_cidr = local.vpc3.isolated_subnet_3_2_cidr

  create_igw = local.vpc3.create_igw
  route_transit_gateway = local.vpc3.route_transit_gateway
  transit_gateway_id = module.TGW.transit_gateway_id
  
  availability_zone_1 = local.vpc3.availability_zone_1
  availability_zone_2 = local.vpc3.availability_zone_2
}

module "ec2_1" {
  source = "./modules/EC2"
  instance_profile_name  = module.iam1.instance_profile_name
  vpc_id = module.vpc1.vpc_id
  instance_subnet_id = module.vpc1.public_subnet_1

  sysname = local.ec2_1.sysname 
  instance_type = local.ec2_1.instance_type
  az = local.ec2_1.availability_zone_1
  security_group_name = local.ec2_1.security_group_name
}

module "ec2_2" {
  source = "./modules/EC2"
  instance_profile_name  = module.iam2.instance_profile_name
  vpc_id = module.vpc2.vpc_id
  instance_subnet_id = module.vpc2.isolated_subnet_1

  sysname = local.ec2_2.sysname 
  instance_type = local.ec2_2.instance_type
  az = local.ec2_2.availability_zone_1
  security_group_name = local.ec2_2.security_group_name
}

module "ec2_3" {
  source = "./modules/EC2"
  instance_profile_name  = module.iam3.instance_profile_name
  vpc_id = module.vpc3.vpc_id
  instance_subnet_id = module.vpc3.isolated_subnet_1

  sysname = local.ec2_3.sysname 
  instance_type = local.ec2_3.instance_type
  az = local.ec2_3.availability_zone_1
  security_group_name = local.ec2_3.security_group_name
}

module "TGW" {
  source = "./modules/TGW"
  sysname = local.tgw.sysname

  vpc1_id = module.vpc1.vpc_id
  vpc1_cidr = local.vpc1.vpc_cidr
  vpc1_public_rt = module.vpc1.public_route_table_id
  vpc1_isolated_rt = module.vpc1.isolated_route_table_id

  vpc2_id = module.vpc2.vpc_id
  vpc2_cidr = local.vpc2.vpc_cidr
  vpc2_rt = module.vpc2.isolated_route_table_id

  vpc3_id = module.vpc3.vpc_id
  vpc3_cidr = local.vpc3.vpc_cidr
  vpc3_rt = module.vpc3.isolated_route_table_id

  subnet1_ids = [ module.vpc1.isolated_subnet_1 ]
  subnet2_ids = [ module.vpc2.isolated_subnet_1 ]
  subnet3_ids = [ module.vpc3.isolated_subnet_1 ]
}