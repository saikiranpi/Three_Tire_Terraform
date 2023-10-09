output "db_instance_address" {
  value = aws_db_instance.rds_db.address
  description = "The address of the RDS instance"
}

output "db_instance_arn" {
  value = aws_db_instance.rds_db.arn
  description = "The ARN of the RDS instance"
}

output "db_instance_endpoint" {
  value = aws_db_instance.rds_db.endpoint
  description = "The connection endpoint of the RDS instance"
}

output "db_instance_identifier" {
  value = aws_db_instance.rds_db.identifier
  description = "The identifier of the RDS instance"
}

# output "app_alb_dns" {
#   value = aws_lb.app_lb.dns_name  
# }
