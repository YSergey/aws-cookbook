

module "DB" {
  source = "./modules/DB"
  sysname = local.db.sysname

  vpc_id = module.VPC.vpc_id
  subnet_a_id = module.VPC.subnet_a_id
  subnet_b_id = module.VPC.subnet_b_id
  availability_zones = local.db.availability_zones

  cluster_identifier = local.db.cluster_identifier
  engine = local.db.engine
  engine_version = local.db.engine_version
  database_name = local.db.database_name
  master_username = local.db.master_username
  instance_class = local.db.instance_class
}

module "EncryptedDB" {
  source = "./modules/EncryptedDB"
  sysname = local.encrypted_db.sysname
  cluster_identifier = local.encrypted_db.cluster_identifier
  database_name = local.encrypted_db.database_name
  engine = local.encrypted_db.engine
  engine_version = local.encrypted_db.engine_version
  master_username = local.encrypted_db.master_username
  instance_class = local.encrypted_db.instance_class

  replicate_source_db_id =  module.DB.rds_instance_id
  db_subnet_group_name =  module.DB.db_subnet_group_name
}

module "VPC" {
  source = "./modules/VPC"
  sysname = local.VPC.sysname

  vpc_cidr = local.VPC.vpc_cidr
  subnet_a_cidr = local.VPC.subnet_a_cidr
  subnet_b_cidr = local.VPC.subnet_b_cidr

  az_a = local.VPC.subnet_a_az
  az_b = local.VPC.subnet_b_az
}

module "IAM" {
  source = "./modules/IAM"
  sysname = local.IAM.sysname
  aws_account_id = data.aws_caller_identity.current.account_id
  aws_db_instance_resource_id = module.DB.rds_instance_id
}

module "EC2" {
  source = "./modules/EC2"
  sysname = local.EC2_A.sysname
  
  vpc_id = module.VPC.vpc_id
  subnet_id =  module.VPC.subnet_a_id
  route_table_id = module.VPC.route_table_id

  instance_name = "${local.EC2_A.sysname}-EC2"
  instance_type = local.EC2_A.instance_type

  create_endpoint = local.EC2_A.create_endpoint

  availability_zone = local.EC2_A.availability_zone
  security_group_name = "${local.EC2_A.sysname}-security-group"
  db_security_group_id = module.DB.db_security_group_id
  region = var.region
  instance_profile = module.IAM.aws_iam_instance_profile
  iam_role_arn = module.IAM.aws_iam_arn
}

