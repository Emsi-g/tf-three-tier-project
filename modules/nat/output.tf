output "priv_rtb_app" {
    value = [for rtb in aws_route_table.pri_rtb_app : rtb.id ]
}