variable "project_name" {}
variable "alb_dns" {}
variable "cf_cert_arn" {}
variable "s3_bucket_regional_dn" {}
variable "uri_name" {}
locals {
  s3_origin_id     = "s3_oac"
}
