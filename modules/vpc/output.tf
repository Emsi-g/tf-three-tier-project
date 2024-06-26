output "vpc_id" {
    value       = aws_vpc.vpc.id
}
output "project_name" {
    value       = var.project_name
}
output "igw_id" {
    value       = aws_internet_gateway.vpc_igw.id
}
output "pub_sub_id" {
    value       = [for subnet in aws_subnet.pub_sub : subnet.id]
}
output "priv_sub_app_id" {
    value       = [for subnet in aws_subnet.priv_sub_app : subnet.id]
}
output "priv_sub_db_id" {
    value       = [for subnet in aws_subnet.priv_sub_db : subnet.id]
}