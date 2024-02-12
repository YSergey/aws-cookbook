
module "iam" {
  source = "./modules/IAM"
}

module "vpc" {
  source = "./modules/vpc"
}

module "alb" {
  source = "./modules/alb"
  my_cert = module.iam.my_cert
  aws_vpc_id = module.vpc.aws_vpc_id
  public_subnet_id = [module.vpc.aws_public_subnet_1, module.vpc.aws_public_subnet_2]
}