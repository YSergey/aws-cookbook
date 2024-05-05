module "S3" {
    source             = "./modules/S3"
    sysname            = var.sysname
    env                = var.env

    bucket_name = "${var.sysname}-${var.env}-bucket"
    bucket_source_path = "index.html"
    bucket_object_key = "index.html"
    cloudfront_distribution_arn = module.CloudFront.cloudfront_distribution_arn
}

module "CloudFront" {
    source  = "./modules/CloudFront"
    sysname = var.sysname
    env     = var.env

    bucket_id = module.S3.bucket_id
    bucket_regional_domain_name = module.S3.bucket_regional_domain_name
}
