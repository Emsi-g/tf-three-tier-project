project_name        = "tf-three-tier-project"

# VPC
vpc_cidr            = "192.168.0.0/16"
pub_sub_cidr        = ["192.168.10.0/24", "192.168.11.0/24"]
priv_sub_app_cidr   = ["192.168.20.0/24", "192.168.21.0/24"]
priv_sub_db_cidr    = ["192.168.30.0/24", "192.168.31.0/24"]

# EC2
key_name            = "tf-servers-keypair"
public_key_path     = "../modules/asg/key/keypair.pub"

# RDS
db_username         = "admin"
db_password         = "a*AUms^1)kD^!Kj"

# ACM R53
domain_name         = "example.com"
uri_name            = "tfthreetier.example.com"

# S3
bucket_name         = "s3-bucket-static-objects"        # S3 bucket for static objects