module "IAM" {
  source = "./modules/IAM"
  sysname = local.IAM.sysname
  bucket_arn = module.s3.bucket_arn
}

module "s3" {
  source = "./modules/S3"

  sysname = local.s3.sysname
  bucket_name = local.s3.bucket_name
  object_ownership = local.s3.object_ownership
  acl = local.s3.acl
}

module "S3_access_point_A" {
  source = "./modules/S3_access_point"
  sysname = local.S3_access_point_A.sysname

  aws_iam_role_arn = module.IAM.aws_iam_role_arn

  bucket_name = local.s3.bucket_name

  vpc_id = module.VPC.vpc_id
}

module "S3_access_point_B" {
  source = "./modules/S3_access_point"
  sysname = local.S3_access_point_B.sysname

  aws_iam_role_arn = module.IAM.aws_iam_role_arn

  bucket_name = local.s3.bucket_name

  vpc_id = module.VPC.vpc_id
}

module "VPC" {
  source = "./modules/VPC"
  sysname = local.vpc.sysname

  vpc_cidr_block = local.vpc.vpc_cidr_block
  subnet_a_cidr = local.vpc.subnet_a_cidr_block
  subnet_b_cidr = local.vpc.subnet_b_cidr_block
  subnet_a_az = local.vpc.subnet_a_az
  subnet_b_az = local.vpc.subnet_b_az
}

module "EC2_A" {
  source = "./modules/EC2"
  sysname = "${local.EC2_A.sysname}"
  region = var.region

  security_group_name = local.EC2_A.security_group_name
  instance_profile = module.IAM.instance_profile
  instance_name = local.EC2_A.instance_name
  instance_type = local.EC2_A.instance_type

  vpc_id = module.VPC.vpc_id
  subnet_id = module.VPC.subnet_a_id
  availability_zone = module.VPC.subnet_a_az
  create_endpoint = local.EC2_A.create_ssm_endpoint
}

module "EC2_B" {
  source = "./modules/EC2"
  sysname = "${local.EC2_B.sysname}"
  region = var.region

  security_group_name = local.EC2_B.security_group_name
  instance_profile = module.IAM.instance_profile
  instance_name = local.EC2_B.instance_name
  instance_type = local.EC2_B.instance_type

  vpc_id = module.VPC.vpc_id
  subnet_id = module.VPC.subnet_b_id
  availability_zone = module.VPC.subnet_b_az
  create_endpoint = local.EC2_B.create_ssm_endpoint
}