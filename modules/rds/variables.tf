variable "project_name" {}
variable "vpc_id" {}
variable "priv_sub_db_id" {}
variable "db_sg" {}
variable "db_username" {}
variable "db_password" {}
variable "instance_class" {
    default = "db.t3.micro"
}
variable "db_storage" {
    default = 30
}
variable "db_max_storage" {
    default = 100
}
variable "db_storage_type" {
    default = "gp3"
}
variable "db_identifier" {
    default = "mysqldbtest"
}
variable "engine" {
    default = "mysql"
}
variable "engine_version" {
    default = "8.0.35"
}
variable "parameter_group_name" {
    default = "default.mysql8.0"
}
variable "final_ss_identifier" {
    default = "final-snapshot-DB"
}
