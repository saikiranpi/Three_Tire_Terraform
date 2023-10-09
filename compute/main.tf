data "aws_ssm_parameter" "three_tier_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#aws launch template for web-tier
resource "aws_launch_template" "web_tier_instance" {
  name_prefix = "web_tier_instance"
  instance_type = var.instance_type
  image_id = data.aws_ssm_parameter.three_tier_ami.value
  vpc_security_group_ids = [var.frontend_app_sg]
}

resource "aws_autoscaling_group" "web_tier_asg" {
  name = "web-tier_asg"
  vpc_zone_identifier = var.public_subnets
  min_size = 2
  max_size = 2
  desired_capacity = 2
  launch_template {
    id = aws_launch_template.web_tier_instance.id
    version = "$Latest"
  }
}
resource "aws_autoscaling_attachment" "web_asg_attach" {
  autoscaling_group_name = aws_autoscaling_group.web_tier_asg.id
  lb_target_group_arn = var.web_tg
}

#Lauch template for app-tier
resource "aws_launch_template" "app_tier_instance" {
  name_prefix = "app_tier_instance"
  instance_type = var.instance_type
  image_id = data.aws_ssm_parameter.three_tier_ami.value
  vpc_security_group_ids = [var.app_sg]
}
resource "aws_autoscaling_group" "app_tier_asg" {
  name = "app_tier_asg"
  vpc_zone_identifier = var.app_subnets
  min_size = 2
  max_size = 2
  desired_capacity = 2  
  launch_template {
    id = aws_launch_template.app_tier_instance.id
    version = "$latest"
  }
}
resource "aws_autoscaling_attachment" "app_asg_attach" {
    autoscaling_group_name = aws_autoscaling_group.app_tier_asg.id
    lb_target_group_arn = var.app_tg
}