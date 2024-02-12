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
}

module "Lambda" {
  source = "./modules/Lambda"

  vpc_id = module.VPC.vpc_id
  subnet_ids = [ module.VPC.subnet_a_id, module.VPC.subnet_b_id ]

  lambda_execution_role_arn = module.IAM.lambda_role_arn
  function_name = local.Lambda.function_name
  file_name = local.Lambda.file_name
  handler = local.Lambda.handler
  runtime = local.Lambda.runtime

  efs_accesspoint_arn = module.EFS.efs_access_point_arn
  efs_sd_id = module.EFS.efs_sg_id

}

module "EFS" {
  source = "./modules/EFS"

  vpc_id = module.VPC.vpc_id
  lambda_sg_id = module.Lambda.lambda_security_group_id

  subnet_a_id = module.VPC.subnet_a_id
  subnet_b_id = module.VPC.subnet_b_id
  sg_instance_id = module.EC2.sg_instance_id
}

module "EC2" {
  source = "./modules/EC2"
  sysname = local.EC2_A.sysname
  
  vpc_id = module.VPC.vpc_id
  subnet_id =  module.VPC.subnet_a_id
  route_table_id = module.VPC.route_table_a_id

  instance_name = "${local.EC2_A.sysname}-EC2"
  instance_type = local.EC2_A.instance_type

  create_endpoint = local.EC2_A.create_endpoint

  availability_zone = local.EC2_A.availability_zone
  security_group_name = "${local.EC2_A.sysname}-security-group"

  region = var.region
  instance_profile = module.IAM.aws_iam_instance_profile
  iam_role_arn = module.IAM.aws_iam_arn
}

