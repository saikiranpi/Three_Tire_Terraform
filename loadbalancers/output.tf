output "app_alb_dns" {
  value = aws_lb.app_lb.dns_name  
}

output "app_alb_endpoint" {
  value = aws_lb.app_lb.arn  
}

output "app_tg_name" {
  value = aws_lb_target_group.app_tg.name  
}

output "app_tg" {
  value = aws_lb_target_group.app_tg.arn 
}

output "web_alb_dns" {
  value = aws_lb.web_lb.dns_name
}

output "web_alb_endpoint" {
  value = aws_lb.web_lb.dns_name
}

output "web_tg_name" {
  value = aws_lb_target_group.web_tg.name
}

output "web_tg" {
  value = aws_lb_target_group.web_tg.arn
}