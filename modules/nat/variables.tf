variable "project_name" {}
variable "vpc_id" {}
variable "igw_id" {}
variable "pub_sub_id" {}
variable "priv_sub_app_id" {}
variable "priv_sub_db_id" {}

# Data source to get all AZs in region
data "aws_availability_zones" "availability_zone" {}