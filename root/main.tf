module "vpc" {
    source                  = "../modules/vpc"
    project_name            = var.project_name
    vpc_cidr                = var.vpc_cidr
    pub_sub_cidr            = var.pub_sub_cidr
    priv_sub_app_cidr       = var.priv_sub_app_cidr
    priv_sub_db_cidr        = var.priv_sub_db_cidr
    priv_rtb_app            = module.nat.priv_rtb_app
}

module "nat" {
    source                  = "../modules/nat"
    project_name            = var.project_name
    vpc_id                  = module.vpc.vpc_id
    igw_id                  = module.vpc.igw_id
    pub_sub_id              = module.vpc.pub_sub_id 
    priv_sub_app_id         = module.vpc.priv_sub_app_id
    priv_sub_db_id          = module.vpc.priv_sub_db_id
}

module "sg" {
    source                  = "../modules/sg"
    project_name            = var.project_name
    vpc_id                  = module.vpc.vpc_id
}

module "asg" {
    source                  = "../modules/asg"
    project_name            = var.project_name
    priv_sub_app_id         = module.vpc.priv_sub_app_id
    pub_sub_id              = module.vpc.pub_sub_id 
    app_sg                  = module.sg.app_sg
    web_sg                  = module.sg.web_sg
    instance_profile_role   = module.iam.instance_profile_role
    tg_arn_int              = module.alb.tg_arn_int
    tg_arn                  = module.alb.tg_arn
    key_name                = var.key_name
    public_key_path         = var.public_key_path
}

module "alb" {
    source                  = "../modules/alb"
    project_name            = var.project_name
    vpc_id                  = module.vpc.vpc_id
    pub_sub_id              = module.vpc.pub_sub_id
    priv_sub_app_id         = module.vpc.priv_sub_app_id
    alb_sg                  = module.sg.alb_sg
    alb_internal_sg         = module.sg.alb_internal_sg 
    alb_cert_arn            = module.acmr53.alb_cert_arn
    asg_web_name            = module.asg.asg_web_name
    asg_app_name            = module.asg.asg_app_name

}

module "s3" {
    source                  = "../modules/s3"
    project_name            = var.project_name
    bucket_name             = var.bucket_name 
    alb_cf_dist_arn         = module.cloudfront.alb_cf_dist_arn
}

module "rds" {
    source                  = "../modules/rds"
    project_name            = var.project_name
    vpc_id                  = module.vpc.vpc_id
    priv_sub_db_id          = module.vpc.priv_sub_db_id
    db_sg                   = module.sg.db_sg
    db_username             = var.db_username
    db_password             = var.db_password
}

module "acmr53" {
    source                  = "../modules/acmr53"
    providers = {
      aws.acm               = aws.acm
      aws.route53_acc       = aws.route53_acc
    }
    cf_name                 = module.cloudfront.cf_name
    cf_zone_id              = module.cloudfront.cf_zone_id
    domain_name             = var.domain_name 
    uri_name                = var.uri_name
}

module "iam" {
    source                  = "../modules/iam"
    project_name            = var.project_name
}

module "cloudfront" {
    source                  = "../modules/cloudfront"
    project_name            = var.project_name
    alb_dns                 = module.alb.alb_dns
    cf_cert_arn             = module.acmr53.cf_cert_arn
    s3_bucket_regional_dn   = module.s3.s3_bucket_regional_dn
    uri_name                = var.uri_name
}