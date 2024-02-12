module "VPC" {
  source = "./modules/VPC"
  sysname = local.VPC.sysname
  region = var.region

  vpc_cidr = local.VPC.vpc_cidr
  subnets_variable = local.VPC.subnets
  route_table_variable = local.VPC.route_table
}

module "DB" {
  source = "./modules/DB"
  sysname = local.db.sysname

  vpc_id = module.VPC.vpc_id
  vpc_cidr = module.VPC.vpc_cidr
  subnet_a_id = module.VPC.subnet_ids[3]
  subnet_b_id = module.VPC.subnet_ids[4]
  availability_zones = local.db.availability_zones

  cluster_identifier = local.db.cluster_identifier
  engine = local.db.engine
  engine_version = local.db.engine_version
  database_name = local.db.database_name
  master_username = local.db.master_username
  instance_class = local.db.instance_class
}


module "EC2" {
  source = "./modules/EC2"
  sysname = local.EC2_A.sysname
  region = var.region
  
  vpc_id = module.VPC.vpc_id
  subnet_id =  module.VPC.subnet_ids[1]
  availability_zone = local.EC2_A.availability_zone

  instance_name = "${local.EC2_A.sysname}-EC2"
  instance_type = local.EC2_A.instance_type

  security_group_name = "${local.EC2_A.sysname}-security-group"
  db_security_group_id = module.DB.db_security_group_id
  aws_db_instance_resource_id = module.DB.rds_instance_id
  aws_account_id = local.EC2_A.account_id
}

