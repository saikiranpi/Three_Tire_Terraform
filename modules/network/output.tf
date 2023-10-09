output "vpc_id" {
  value = aws_vpc.three-tier-vpc.id
}

output "db_subnet_group_name" {
  value = aws_db_subnet_group.db_sn_group.*.name
}

output "rds_db_subnet_group" {
  value = aws_db_subnet_group.db_sn_group.*.id
}

output "rds_sg" {
  value = aws_security_group.db_sg.id
}

output "frontend_app_sg" {
  value = aws_security_group.web_sg.id
}

output "frontend_lb_sg" {
  value = aws_security_group.web_lb_sg.id
}

output "app_sg" {
  value = aws_security_group.app_sg.id
}

output "app_lb_sg" {
  value = aws_security_group.app_lb_sg.id
}

output "public_subnets" {
  value = aws_subnet.pb_sn.*.id
}

output "app_subnets" {
  value = aws_subnet.app_pr_sn.*.id
}

output "db_subnets" {
  value = aws_subnet.db_pr_sn.*.id
}