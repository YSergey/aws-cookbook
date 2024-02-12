
module "iam" {
  source = "./modules/iam"
}

module "vpc1" {
  source = "./modules/VPC"

  sysname = local.vpc1.sysname
  cidr_block = local.vpc1.vpc_cidr

  public_subnet_1_cidr = local.vpc1.public_subnet_1_1_cidr
  isolated-subnet_1_cidr = local.vpc1.isolated-subnet_1_1_cidr
  public_subnet_2_cidr = local.vpc1.public_subnet_1_2_cidr
  isolated-subnet_2_cidr = local.vpc1.isolated-subnet_1_2_cidr 

  availability_zone_1 = local.vpc1.availability_zone_1
  availability_zone_2 = local.vpc1.availability_zone_2
}

module "vpc2" {
  source = "./modules/VPC"

  sysname = local.vpc2.sysname
  cidr_block = local.vpc2.vpc_cidr

  public_subnet_1_cidr = local.vpc2.public_subnet_2_1_cidr 
  isolated-subnet_1_cidr = local.vpc2.isolated-subnet_2_1_cidr
  public_subnet_2_cidr = local.vpc2.public_subnet_2_2_cidr
  isolated-subnet_2_cidr = local.vpc2.isolated-subnet_2_2_cidr
  
  availability_zone_1 = local.vpc2.availability_zone_1
  availability_zone_2 = local.vpc2.availability_zone_2
}

module "vpc3" {
  source = "./modules/VPC"

  sysname = local.vpc3.sysname
  cidr_block = local.vpc3.vpc_cidr

  public_subnet_1_cidr = local.vpc3.public_subnet_3_1_cidr
  isolated-subnet_1_cidr = local.vpc3.isolated-subnet_3_1_cidr
  public_subnet_2_cidr = local.vpc3.public_subnet_3_2_cidr
  isolated-subnet_2_cidr = local.vpc3.isolated-subnet_3_2_cidr
  
  availability_zone_1 = local.vpc3.availability_zone_1
  availability_zone_2 = local.vpc3.availability_zone_2
}

module "ec2_1" {
  source = "./modules/EC2"

  sysname = local.ec2_1.sysname 
  instance_profile_name  = module.iam.instance_profile_name
  vpc_id = module.vpc1.vpc_id
  instance_subnet_id = module.vpc1.isolated_subnet_1_1
  availability_zone =local.ec2_3.availability_zone_1
}

module "ec2_2" {
  source = "./modules/EC2"

  sysname = local.ec2_2.sysname 
  instance_profile_name  = module.iam.instance_profile_name
  vpc_id = module.vpc2.vpc_id
  instance_subnet_id = module.vpc2.isolated_subnet_1_1
  availability_zone = local.ec2_3.availability_zone_1
}

module "ec2_3" {
  source = "./modules/EC2"

  sysname = local.ec2_3.sysname 
  instance_profile_name  = module.iam.instance_profile_name
  vpc_id = module.vpc3.vpc_id
  instance_subnet_id = module.vpc3.isolated_subnet_1_1
  availability_zone = local.ec2_3.availability_zone_1
}