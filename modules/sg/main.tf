# Create ALB INTERNET FACING SG
resource "aws_security_group" "alb_sg" {
    vpc_id                          = var.vpc_id
    name                            = "${var.project_name}-alb-sg"
    tags = {
      Name                          = "${var.project_name}-alb-sg"
    }
    ingress = [
        {
            description             = "ALB SG"
            cidr_blocks             = [ "0.0.0.0/0"]
            to_port                 = 80
            from_port               = 80
            protocol                = "TCP"
            security_groups         = []
            ipv6_cidr_blocks        = []
            prefix_list_ids         = []
            self                    = false
        },
        {
            description             = "ALB SG"
            cidr_blocks             = [ "0.0.0.0/0"]
            to_port                 = 443
            from_port               = 443
            protocol                = "TCP"
            security_groups         = []
            ipv6_cidr_blocks        = []
            prefix_list_ids         = []
            self                    = false
        }
    ]
    egress {
            cidr_blocks             = [ "0.0.0.0/0"]
            to_port                 = 0
            from_port               = 0
            protocol                = -1
    }
}

# Create ALB INTERNAL SG
resource "aws_security_group" "alb_internal_sg" {
    vpc_id                          = var.vpc_id
    name                            = "${var.project_name}-alb-int-sg"
    tags = {
      Name                          = "${var.project_name}-alb-int-sg"
    }
    ingress = [
        {
            description             = "ALB INT SG"
            cidr_blocks             = []
            to_port                 = 80
            from_port               = 80
            protocol                = "TCP"
            security_groups         = [ aws_security_group.web_sg.id ]
            ipv6_cidr_blocks        = []
            prefix_list_ids         = []
            self                    = false
        },
        {
            description             = "ALB INT SG"
            cidr_blocks             = []
            to_port                 = 443
            from_port               = 443
            protocol                = "TCP"
            security_groups         = [ aws_security_group.web_sg.id ]
            ipv6_cidr_blocks        = []
            prefix_list_ids         = []
            self                    = false
        }
    ]
    egress {
            cidr_blocks             = [ "0.0.0.0/0"]
            to_port                 = 0
            from_port               = 0
            protocol                = -1
    }
}

# Create WEB SG
resource "aws_security_group" "web_sg" {
    vpc_id                          = var.vpc_id
    name                            = "${var.project_name}-web-sg"
    tags = {
      Name                          = "${var.project_name}-web-sg"
    }
    ingress = [
        {
            description             = "WEB SG"
            cidr_blocks             = []
            to_port                 = 80
            from_port               = 80
            protocol                = "TCP"
            security_groups         = [ aws_security_group.alb_sg.id ]
            ipv6_cidr_blocks        = []
            prefix_list_ids         = []
            self                    = false
        },
        {
            description             = "WEB SG"
            cidr_blocks             = []
            to_port                 = 443
            from_port               = 443
            protocol                = "TCP"
            security_groups         = [ aws_security_group.alb_sg.id ]
            ipv6_cidr_blocks        = []
            prefix_list_ids         = []
            self                    = false
        }
    ]
    egress {
            cidr_blocks             = [ "0.0.0.0/0"]
            to_port                 = 0
            from_port               = 0
            protocol                = -1
    }
}

# Create APP SG
resource "aws_security_group" "app_sg" {
    vpc_id                          = var.vpc_id
    name                            = "${var.project_name}-app-sg"
    tags = {
      Name                          = "${var.project_name}-app-sg"
    }
    ingress = [
        {
            description             = "APP SG"
            cidr_blocks             = []
            to_port                 = 80
            from_port               = 80
            protocol                = "TCP"
            security_groups         = [ aws_security_group.alb_internal_sg.id ]
            ipv6_cidr_blocks        = []
            prefix_list_ids         = []
            self                    = false
        },
        {
            description             = "APP SG"
            cidr_blocks             = []
            to_port                 = 443
            from_port               = 443
            protocol                = "TCP"
            security_groups         = [ aws_security_group.alb_internal_sg.id ]
            ipv6_cidr_blocks        = []
            prefix_list_ids         = []
            self                    = false
        }
    ]
    egress {
            cidr_blocks             = [ "0.0.0.0/0"]
            to_port                 = 0
            from_port               = 0
            protocol                = -1
    }
}

# Create DB SG
resource "aws_security_group" "db_sg" {
    vpc_id                          = var.vpc_id
    name                            = "${var.project_name}-db-sg"
    tags = {
      Name                          = "${var.project_name}-db-sg"
    }
    ingress = [
        {
            description             = "DB SG"
            cidr_blocks             = []
            to_port                 = 3306
            from_port               = 3306
            protocol                = "TCP"
            security_groups         = [ aws_security_group.app_sg.id ]
            ipv6_cidr_blocks        = []
            prefix_list_ids         = []
            self                    = false
        }
    ]
    egress {
            cidr_blocks             = [ "0.0.0.0/0"]
            to_port                 = 0
            from_port               = 0
            protocol                = -1
    }
}