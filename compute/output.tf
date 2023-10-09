output "web_asg" {
    value = aws_autoscaling_group.web_tier_asg.arn
}