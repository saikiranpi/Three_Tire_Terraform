variable "dbuser" {
  type      = string
  sensitive = true
}
variable "dbpassword" {
  type      = string
  sensitive = true
}
variable "db_name" {
  type = string
}
variable "my_ip" {}