# Key pair
resource "aws_key_pair" "auth" {
    key_name                            = var.key_name
    public_key                          = file(var.public_key_path)
}

# Create a launch template for web server
resource "aws_launch_template" "web-launch-temp" {
    name                                = "${var.project_name}-web-lt"
    instance_type                       = var.instance_type_web
    image_id                            = data.aws_ami.ami_server.id
    # vpc_security_group_ids            = [ var.web_sg ]
    key_name                            = aws_key_pair.auth.id
    user_data                           = filebase64("../modules/asg/scripts/user-data-web.sh")
    iam_instance_profile {
      name                              = var.IAMroleWeb
    }
    network_interfaces {
        associate_public_ip_address     = true
        security_groups                 = [ var.web_sg ]
    }
    tag_specifications {
      resource_type                     = "instance"
            tags                        = {
            Name                        = "web_server"
        }
    }
}

# Create an ASG for web server
resource "aws_autoscaling_group" "web_asg" {
    name                                = "${var.project_name}-web-asg"
    vpc_zone_identifier                 = [ var.pub_sub_id[0], var.pub_sub_id[1] ]
    target_group_arns                   = [ var.tg_arn ]
    desired_capacity                    = var.desired_capacity
    min_size                            = var.min_size
    max_size                            = var.max_size
    health_check_grace_period           = 300
    health_check_type                   = var.health_check_type
    enabled_metrics = [
        "GroupMinSize",
        "GroupMaxSize",
        "GroupDesiredCapacity",
        "GroupInServiceInstances",
        "GroupTotalInstances"
    ]
    metrics_granularity                 = "1Minute"
    launch_template {
        id                              = aws_launch_template.web-launch-temp.id
        version                         = aws_launch_template.web-launch-temp.latest_version
    }
}

# Create a launch template for app server
resource "aws_launch_template" "app-launch-temp" {
    name                                = "${var.project_name}-app-lt"
    instance_type                       = var.instance_type_app
    image_id                            = data.aws_ami.ami_server.id
    # vpc_security_group_ids            = [ var.app_sg ]
    key_name                            = aws_key_pair.auth.id
    user_data                           = filebase64("../modules/asg/scripts/user-data-app.sh")
    iam_instance_profile {
      name                              = var.instance_profile_role
    }
    network_interfaces {
        associate_public_ip_address     = false
        security_groups                 = [ var.app_sg ]
    }
    tag_specifications {
      resource_type                     = "instance"
            tags                        = {
            Name                        = "app_server"
        }
    }
}

# Create an ASG for app server
resource "aws_autoscaling_group" "app_asg" {
    name                                = "${var.project_name}-app-asg"
    vpc_zone_identifier                 = [ var.priv_sub_app_id[0], var.priv_sub_app_id[1] ]
    target_group_arns                   = [ var.tg_arn_int ]
    desired_capacity                    = var.desired_capacity
    min_size                            = var.min_size
    max_size                            = var.max_size
    health_check_grace_period           = 300
    health_check_type                   = var.health_check_type
    enabled_metrics = [
        "GroupMinSize",
        "GroupMaxSize",
        "GroupDesiredCapacity",
        "GroupInServiceInstances",
        "GroupTotalInstances"
    ]
    metrics_granularity                 = "1Minute"
    launch_template {
        id                              = aws_launch_template.app-launch-temp.id
        version                         = aws_launch_template.app-launch-temp.latest_version
    }
}