
module "iam" {
  source = "./modules/IAM"
}

module "vpc" {
  source = "./modules/vpc"
  instance_name = module.iam.instance_profile_name
}