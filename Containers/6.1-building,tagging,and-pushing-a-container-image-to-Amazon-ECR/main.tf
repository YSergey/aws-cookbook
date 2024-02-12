module "IAM" {
    source = "./modules/IAM"
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

module "ECR" {
    source = "./modules/ECR"
    sysname = local.ECR.sysname
}

module "SSH_KEYGEN" {
    source = "./modules/SSH_KEYGEN"
}