
module "iam" {
  source = "./modules/iam"
}

module "s3" {
  source = "./modules/s3"
}

module "vpc" {
  source = "./modules/vpc"
  instance_profile_name  = module.iam.instance_profile_name
  bucket_name = module.s3.bucket_name
}