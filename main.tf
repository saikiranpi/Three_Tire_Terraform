provider "aws" {
  region = local.location
}

locals {
  instance_type = "t2.micro"
  location      = "us-east-1"

}

module "network" {
  source           = "../modules/network"
  my_ip            = var.my_ip
  pb_sn_count      = 2
  app_pr_sn_count  = 2
  db_pr_sn_count   = 2
  azs              = 2
  availabilityzone = "us-east-1a"
}

module "loadbalancer" {
  source          = "../modules/loadbalancer"
  frontend_lb_sg  = module.network.frontend_lb_sg
  app_lb_sg       = module.network.app_lb_sg
  vpc_id          = module.network.vpc_id
  myazs           = 2
  public_subnets  = module.network.public_subnets
  private_subnets = module.network.app_subnets
}

module "db" {
  source              = "../modules/database"
  db_storage          = 10
  db_engine_version   = "8.0.30"
  db_identifier       = "my-3-tier-rds-db"
  db_instance_class   = "db.t2.micro"
  rds_db_subnet_group = module.network.rds_db_subnet_group[0]
  rds_sg              = module.network.rds_sg
  dbpassword          = var.dbpassword
  dbuser              = var.dbuser
  db_name             = var.db_name
}

module "compute" {
  source          = "../modules/compute"
  frontend_app_sg = module.network.frontend_app_sg
  app_sg          = module.network.app_sg
  web_tg          = module.loadbalancer.web_tg
  web_tg_name     = module.loadbalancer.web_tg_name
  app_tg          = module.loadbalancer.app_tg
  app_tg_name     = module.loadbalancer.app_tg_name
  instance_type   = "t2.micro"
  app_subnets     = module.network.app_subnets
  public_subnets  = module.network.public_subnets
}