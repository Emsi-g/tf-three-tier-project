variable "project_name" {}
variable "vpc_cidr" {}
variable "priv_rtb_app" {}
variable "pub_sub_cidr" {
    type = list(string)
}
variable "priv_sub_app_cidr" {
    type = list(string)
}
variable "priv_sub_db_cidr" {
    type = list(string)
}

data "aws_availability_zones" "availability_zone" {}

locals {
  azs = data.aws_availability_zones.availability_zone.names
}