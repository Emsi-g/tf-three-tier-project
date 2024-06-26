output "asg_web_name" {
    value   = aws_autoscaling_group.web_asg.name  
}

output "asg_app_name" {
    value   = aws_autoscaling_group.app_asg.name  
}