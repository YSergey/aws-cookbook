

module "DB" {
  source = "./modules/DB"
  sysname = local.db.sysname

  vpc_id = module.VPC.vpc_id
  vpc_cidr = module.VPC.vpc_cidr
  subnet_a_id = module.VPC.subnet_db_a_id
  subnet_b_id = module.VPC.subnet_db_b_id
  availability_zones = local.db.availability_zones

  ec2_sg_id = module.EC2.ec2_sg_id

  cluster_identifier = local.db.cluster_identifier
  engine = local.db.engine
  engine_version = local.db.engine_version
  database_name = local.db.database_name
  master_username = local.db.master_username
  instance_class = local.db.instance_class
}


module "VPC" {
  source = "./modules/VPC"
  sysname = local.VPC.sysname
  region = var.region

  vpc_cidr = local.VPC.vpc_cidr
  subnet_public_cidr = local.VPC.subnet_public
  subnet_ec2_a_cidr = local.VPC.subnet_ec2_a_cidr
  subnet_ec2_b_cidr = local.VPC.subnet_ec2_b_cidr
  subnet_db_a_cidr = local.VPC.subnet_db_a_cidr
  subnet_db_b_cidr = local.VPC.subnet_db_b_cidr

  az_a = local.VPC.subnet_a_az
  az_b = local.VPC.subnet_b_az
}


module "EC2" {
  source = "./modules/EC2"
  sysname = local.EC2_A.sysname
  
  vpc_id = module.VPC.vpc_id
  subnet_id =  module.VPC.subnet_ec2_a_id

  instance_name = "${local.EC2_A.sysname}-EC2"
  instance_type = local.EC2_A.instance_type
  
  availability_zone = local.EC2_A.availability_zone
  region = var.region
}

