# VPC
variable "project_name" {}
variable "vpc_cidr" {}
variable "pub_sub_cidr" {
    type = list(string)
}
variable "priv_sub_app_cidr" {
    type = list(string)
}
variable "priv_sub_db_cidr" {
    type = list(string)
}

# EC2
variable "key_name" {}
variable "public_key_path" {}

# RDS
variable "db_username" {}
variable "db_password" {}

# ACM R53
variable "domain_name" {}
variable "uri_name" {}

# S3
variable "bucket_name" {}
