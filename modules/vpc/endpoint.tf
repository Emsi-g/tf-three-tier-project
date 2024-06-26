resource "aws_vpc_endpoint" "s3_endpoint" {
    vpc_id                              = aws_vpc.vpc.id
    service_name                        = "com.amazonaws.ap-southeast-1.s3"
}

resource "aws_vpc_endpoint_route_table_association" "rtb_assoc_s3" {
    count                               = length(var.priv_sub_app_cidr)
    route_table_id                      = var.priv_rtb_app[count.index]
    vpc_endpoint_id                     = aws_vpc_endpoint.s3_endpoint.id
}