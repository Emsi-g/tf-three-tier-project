# Create ALB for internet facing
resource "aws_lb" "alb" {
    name                            = "${var.project_name}-alb"
    internal                        = false
    load_balancer_type              = "application"
    security_groups                 = [ var.alb_sg ]
    subnets                         = [ var.pub_sub_id[0], var.pub_sub_id[1] ]
    enable_deletion_protection      = false
    tags = {
        Name                        = "${var.project_name}-alb"
    }
}

# Create a Target group for internet facing
resource "aws_lb_target_group" "tg" {
    name                            = "${var.project_name}-tg"
    vpc_id                          = var.vpc_id
    port                            = 80
    protocol                        = "HTTP"
    health_check {
        enabled                     = true
        interval                    = 300
        path                        = "/"
        timeout                     = 60
        healthy_threshold           = 2
        unhealthy_threshold         = 5
    }
    lifecycle {
        create_before_destroy       = true
    }
}

# Register alb listener PORT 80
resource "aws_lb_listener" "alb_listener_http" {
    load_balancer_arn               = aws_lb.alb.arn
    port                            = 80
    protocol                        = "HTTP"
    depends_on                      = [ aws_lb_target_group.tg ]
    default_action {
        type                        = "redirect"
        redirect {
            port                    = 443
            protocol                = "HTTPS"
            status_code             = "HTTP_301"  
        }
    }
}

# Register alb listener PORT 443
resource "aws_lb_listener" "alb_listener_https" {
    load_balancer_arn               = aws_lb.alb.arn
    port                            = 443
    protocol                        = "HTTPS"
    certificate_arn                 =  var.alb_cert_arn
    depends_on                      = [ aws_lb_target_group.tg ]
    default_action {
        type                        = "forward"
        target_group_arn            = aws_lb_target_group.tg.arn
    }
}

# Attach ASG to TG
resource "aws_autoscaling_attachment" "aws_asg_attachment" {
    autoscaling_group_name          = var.asg_web_name
    lb_target_group_arn             = aws_lb_target_group.tg.arn
}

# Create ALB for Internal
resource "aws_lb" "alb_int" {
    name                            = "${var.project_name}-alb-int"
    internal                        = true
    load_balancer_type              = "application"
    security_groups                 = [ var.alb_internal_sg ]
    subnets                         = [ var.priv_sub_app_id[0], var.priv_sub_app_id[1] ]
    enable_deletion_protection      = false
    tags = {
        Name                        = "${var.project_name}-alb-int"
    }
}

# Create a Target group for Internal
resource "aws_lb_target_group" "tg_int" {
    name                            = "${var.project_name}-tg-int"
    vpc_id                          = var.vpc_id
    port                            = 80
    protocol                        = "HTTP"
    health_check {
        enabled                     = true
        interval                    = 300
        path                        = "/"
        timeout                     = 60
        healthy_threshold           = 2
        unhealthy_threshold         = 5
    }
    lifecycle {
        create_before_destroy       = true
    }
}

# Register alb int listener PORT 80
resource "aws_lb_listener" "alb_listener_http_int" {
    load_balancer_arn               = aws_lb.alb_int.arn
    port                            = 80
    protocol                        = "HTTP"
    depends_on                      = [ aws_lb_target_group.tg_int ]
    default_action {
        type                        = "forward"
        target_group_arn            = aws_lb_target_group.tg_int.arn
    }
}

# Attach ASG to TG
resource "aws_autoscaling_attachment" "aws_asg_attachment_int" {
    autoscaling_group_name          = var.asg_app_name
    lb_target_group_arn             = aws_lb_target_group.tg_int.arn
}