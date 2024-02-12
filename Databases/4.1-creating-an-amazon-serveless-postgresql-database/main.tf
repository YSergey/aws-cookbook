module "VPC" {
  source = "./modules/VPC"
  sysname = local.VPC.sysname
  region = var.region

  vpc_cidr = local.VPC.vpc_cidr
  subnet_ec2_a_cidr = local.VPC.subnet_ec2_a_cidr
  subnet_ec2_b_cidr = local.VPC.subnet_ec2_b_cidr
  subnet_db_a_cidr = local.VPC.subnet_db_a_cidr
  subnet_db_b_cidr = local.VPC.subnet_db_b_cidr

  az_a = local.VPC.subnet_a_az
  az_b = local.VPC.subnet_b_az

}


module "DB" {
  source = "./modules/DB"
  sysname = local.db.sysname

  vpc_id = module.VPC.vpc_id
  vpc_cidr = module.VPC.vpc_cidr
  subnet_a_id = module.VPC.subnet_db_a_id
  subnet_b_id = module.VPC.subnet_db_b_id

  cluster_identifier = local.db.cluster_identifier
  engine = local.db.engine
  engine_version = local.db.engine_version
  database_name = local.db.database_name
  master_username = local.db.master_username
  engine_mode = local.db.engine_mode

  auto_pause = local.db.auto_pause
  min_capacity = local.db.min_capacity
  max_capacity = local.db.max_capacity
  seconds_until_auto_pause = local.db.seconds_until_auto_pause
}

module "EC2" {
  source = "./modules/EC2"
  sysname = local.EC2_A.sysname
  
  vpc_id = module.VPC.vpc_id
  subnet_id =  module.VPC.subnet_ec2_a_id

  instance_name = "${local.EC2_A.sysname}-EC2"
  instance_type = local.EC2_A.instance_type

  availability_zone = local.EC2_A.availability_zone
  security_group_name = "${local.EC2_A.sysname}-security-group"
  db_security_group_id = module.DB.db_security_group_id
}

