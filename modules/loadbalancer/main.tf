# internet facing loadbalancer
resource "aws_lb" "web_lb" {
  name = "web-lb"
  security_groups = [var.frontend_lb_sg]
  subnets = var.public_subnets
  idle_timeout = 300
}

resource "aws_lb_target_group" "web_tg" {
  name = "web-tg"
  port = 80
  protocol = "tcp"
  vpc_id =  var.vpc_id
}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_lb.arn
  port = 80
  protocol = "tcp"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }

}

# internal facing loadbalancer
resource "aws_lb" "app_lb" {
  name = "app-lb"
  subnets = var.private_subnets
  security_groups = [var.app_lb_sg]
  idle_timeout = 300
}

resource "aws_lb_target_group" "app_tg" {
  name = "app-tg"
  port = 80
  protocol = "tcp"
  vpc_id = var.vpc_id  
}
resource "aws_lb_listener" "app_listener" {
  port = 80
  protocol = "tcp"
  load_balancer_arn = aws_lb.app_lb.arn
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}