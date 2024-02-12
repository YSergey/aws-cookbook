
module "s3" {
  source = "./modules/S3"
  sysname = local.s3.sysname

  bucket_name = local.s3.bucket_name
  object_ownership = local.s3.object_ownership
  acl = local.s3.acl
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
}

module "EC2_A" {
  source = "./modules/EC2"
  sysname = local.EC2_A.sysname
  
  vpc_id = module.VPC.vpc_id
  subnet_id =  module.VPC.subnet_a_id

  instance_name = "${local.EC2_A.sysname}-EC2-A"
  instance_type = local.EC2_A.instance_type

  create_endpoint = local.EC2_A.create_endpoint
  create_snap_shot =  local.EC2_A.create_snap_shot
  ebs_volume_from_snapshot_id = null

  availability_zone = local.EC2_A.availability_zone
  security_group_name = "${local.EC2_A.sysname}-security-group"
  region = var.region
  instance_profile = module.IAM.aws_iam_instance_profile
  iam_role_arn = module.IAM.aws_iam_arn
}

module "EC2_B" {
  source = "./modules/EC2"
  sysname = local.EC2_A.sysname
  
  vpc_id = module.VPC.vpc_id
  #EBS snapshotを作るときは、同じAZでなければならない
  subnet_id =  module.VPC.subnet_b_id

  instance_name = "${local.EC2_B.sysname}-EC2-B"
  instance_type = local.EC2_B.instance_type

  create_endpoint = local.EC2_B.create_endpoint
  create_snap_shot =  local.EC2_B.create_snap_shot
  ebs_volume_from_snapshot_id = module.EC2_A.ebs_volume_from_snapshot_id

  availability_zone = local.EC2_B.availability_zone
  security_group_name = "${local.EC2_B.sysname}-security-group"
  
  region = var.region
  instance_profile = module.IAM.aws_iam_instance_profile
  iam_role_arn = module.IAM.aws_iam_arn
}
