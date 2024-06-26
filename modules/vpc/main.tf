# Create VPC
resource "aws_vpc" "vpc" {
    cidr_block                      = var.vpc_cidr
    enable_dns_hostnames            = true
    enable_dns_support              = true
    tags = {
      Name                          = "${var.project_name}-VPC"
    }
    lifecycle {
      create_before_destroy         = true
    }
}

# Create IGW
resource "aws_internet_gateway" "vpc_igw" {
    vpc_id                          = aws_vpc.vpc.id
    tags = {
      Name                          = "${var.project_name}-igw"
    }
}

# Create public subnet
resource "aws_subnet" "pub_sub" {
    count                         = length(var.pub_sub_cidr)
    vpc_id                        = aws_vpc.vpc.id
    cidr_block                    = var.pub_sub_cidr[count.index]
    availability_zone             = local.azs[count.index]
    map_public_ip_on_launch       = true 
    tags = {
      Name                        = "${var.project_name}-pub-sub-${count.index + 1}"
    }
}

# Create public route table
resource "aws_route_table" "pub_rtb" {
    vpc_id                        = aws_vpc.vpc.id
    route {
        cidr_block                = "0.0.0.0/0"
        gateway_id                = aws_internet_gateway.vpc_igw.id
    }
    tags = {
      Name                        = "${var.project_name}-pub-rtb"
    }
}

# Associate public subnets to public rtb
resource "aws_route_table_association" "assoc_pub1_rtb" {
    count                         = length(var.pub_sub_cidr)
    subnet_id                     = aws_subnet.pub_sub[count.index].id
    route_table_id                = aws_route_table.pub_rtb.id
}

# Create private subnet app
resource "aws_subnet" "priv_sub_app" {
    count                         = length(var.priv_sub_app_cidr)
    vpc_id                        = aws_vpc.vpc.id
    cidr_block                    = var.priv_sub_app_cidr[count.index]
    availability_zone             = local.azs[count.index]
    tags = {
      Name                        = "${var.project_name}-priv-sub-app-${count.index + 1}"
    }
}

# Create private subnet db
resource "aws_subnet" "priv_sub_db" {
    count                         = length(var.priv_sub_db_cidr)
    vpc_id                        = aws_vpc.vpc.id
    cidr_block                    = var.priv_sub_db_cidr[count.index]
    availability_zone             = local.azs[count.index]
    map_public_ip_on_launch       = false 
    tags = {
      Name                        = "${var.project_name}priv-sub-db-${count.index + 1}"
    }
}
