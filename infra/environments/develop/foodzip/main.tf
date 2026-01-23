module "networking" {
  source = "../../../modules/networking"

  name     = "foodzip-develop"
  vpc_cidr = var.vpc_cidr

  azs = var.azs

  public_subnet_cidrs = [
    "10.0.0.0/24",
    "10.0.1.0/24"
  ]

  private_app_subnet_cidrs = [
    "10.0.10.0/24",
    "10.0.11.0/24"
  ]

  private_db_subnet_cidrs = [
    "10.0.20.0/24",
    "10.0.21.0/24"
  ]

  enable_nat_gateway = true
  single_nat_gateway = true # dev barato

  tags = local.common_tags
}

###  Security Groups, EC2, RDS, etc...  ###
module "security_groups" {
  source = "../../../modules/security-groups"

  name   = "foodzip-develop"
  vpc_id = module.networking.vpc_id

  alb_ingress_cidrs = ["0.0.0.0/0"]
  enable_https      = true

  api_container_port      = 8000
  frontend_container_port = 80
  db_port                 = 5432

  tags = local.common_tags
}


