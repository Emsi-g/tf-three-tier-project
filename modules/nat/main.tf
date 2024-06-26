# Create EIP
resource "aws_eip" "nat_eip" {
    count                  = length(var.priv_sub_app_id)
    domain                 = "vpc"
    tags = {
      Name                 = "${var.project_name}-nat-eip"
    }
}

# Create NAT Gateway
resource "aws_nat_gateway" "nat_gw" {
    count                  = length(var.priv_sub_app_id)
    allocation_id          = aws_eip.nat_eip[count.index].id
    subnet_id              = var.pub_sub_id[count.index]
    depends_on             = [ var.igw_id ]
    tags = {
      Name                 = "${var.project_name}-nat-gw"
    }
}

# Create private route table 
resource "aws_route_table" "pri_rtb_app" {
    count                  = length(var.priv_sub_app_id)
    vpc_id                 = var.vpc_id
    route {
        cidr_block         = "0.0.0.0/0"
        gateway_id         = aws_nat_gateway.nat_gw[count.index].id
    }
    tags = {
        Name               = "${var.project_name}-priv-rtb-app-${count.index + 1}"
    }
}

# Associate private subnets to private route table
resource "aws_route_table_association" "assoc_pri_rtb_1" {
    count                  = length(var.priv_sub_app_id)
    subnet_id              = var.priv_sub_app_id[count.index]
    route_table_id         = aws_route_table.pri_rtb_app[count.index].id
}

# Create private route table  DB
resource "aws_route_table" "pri_rtb_db" {
    count                  = length(var.priv_sub_db_id)
    vpc_id                 = var.vpc_id
    route {
        cidr_block         = "0.0.0.0/0"
        gateway_id         = aws_nat_gateway.nat_gw[count.index].id
    }
    tags = {
        Name               = "${var.project_name}-priv-rtb-db-${count.index + 1}"
    }
}

# Associate private subnets to private route table
resource "aws_route_table_association" "assoc_pri_rtb_2" {
    count                  = length(var.priv_sub_db_id)
    subnet_id              = var.priv_sub_db_id[count.index]
    route_table_id         = aws_route_table.pri_rtb_db[count.index].id
}