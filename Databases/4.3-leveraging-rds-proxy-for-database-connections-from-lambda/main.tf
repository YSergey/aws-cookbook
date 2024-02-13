module "VPC" {
  source = "./modules/VPC"
  sysname = local.VPC.sysname

  vpc_cidr = local.VPC.vpc_cidr
  subnet_public_cidr = local.VPC.subnet_public_cidr
  subnet_ec2_a_cidr = local.VPC.subnet_ec2_a_cidr
  subnet_ec2_b_cidr = local.VPC.subnet_ec2_b_cidr
  subnet_db_a_cidr = local.VPC.subnet_db_a_cidr
  subnet_db_b_cidr = local.VPC.subnet_db_b_cidr

  az_a = local.VPC.subnet_a_az
  az_b = local.VPC.subnet_b_az

  region = var.region
}

module "DB" {
  source = "./modules/DB"
  sysname = local.db.sysname

  vpc_id = module.VPC.vpc_id
  vpc_cidr = module.VPC.vpc_cidr
  subnet_a_id = module.VPC.subnet_db_a_id
  subnet_b_id = module.VPC.subnet_db_b_id
  availability_zones = local.db.availability_zones
  lambda_sg_id = module.Lambda.lambda_sg
  ec2_sg_id = module.EC2.ec2_sg_id

  cluster_identifier = local.db.cluster_identifier
  engine = local.db.engine
  engine_version = local.db.engine_version
  database_name = local.db.database_name
  master_username = local.db.master_username
  instance_class = local.db.instance_class
}

module "Lambda" {
  source = "./modules/Lambda"
  sysname = local.db.sysname

  vpc_id = module.VPC.vpc_id
  vpc_cidr = module.VPC.vpc_cidr
  subnet_ids = [ module.VPC.subnet_db_a_id, module.VPC.subnet_db_b_id ]

  function_name = local.Lambda.function_name 
  handler = local.Lambda.handler
  runtime = local.Lambda.runtime
  file_name = local.Lambda.file_name

  db_proxy_sg_id = module.DB.db_proxy_sg_id

  # AWS_REGION = var.region
  DB_HOST = module.DB.rds_proxy_endpoint
  USER_NAME = local.db.master_username

}

module "EC2" {
  source = "./modules/EC2"
  sysname = local.EC2_A.sysname
  
  vpc_id = module.VPC.vpc_id
  subnet_id =  module.VPC.subnet_ec2_a_id

  route_table_id = module.VPC.ec2_a_route_table_id

  instance_name = "${local.EC2_A.sysname}-EC2"
  instance_type = local.EC2_A.instance_type


  availability_zone = local.EC2_A.availability_zone
  security_group_name = "${local.EC2_A.sysname}-security-group"
  db_security_group_id = module.DB.db_security_group_id
  
}

