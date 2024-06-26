# Vars for aws_launch_template
variable "project_name" {}
variable "app_sg" {}
variable "web_sg" {}
variable "key_name" {}
variable "public_key_path" {}
variable "instance_profile_role" {}
variable "instance_type_web" {
    default = "t3.small"
}
variable "instance_type_app" {
    default = "t3.small"
}
variable "IAMroleWeb" {
    default = "AmazonSSMRoleForInstancesQuickSetup"
}

# Vars for aws_autoscaling_groug
variable "priv_sub_app_id" {}
variable "pub_sub_id" {}
variable "tg_arn" {}
variable "tg_arn_int" {}
variable "desired_capacity" {
    type = number
    default = 2
}
variable "min_size" {
    type = number
    default = 2
}
variable "max_size" {
    type = number
    default = 3
}
variable "health_check_type" {
    default = "ELB"
}


