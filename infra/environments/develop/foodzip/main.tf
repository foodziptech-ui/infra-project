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

### route53 zone data source ###
module "route53_zone" {
  source      = "../../../modules/route53-zone"
  domain_name = "foodzip.com.br"
  tags        = local.common_tags
}

output "route53_name_servers" {
  value = module.route53_zone.name_servers
}

module "acm" {
  source = "../../../modules/acm"

  domain_name    = "foodzip.com.br"
  hosted_zone_id = module.route53_zone.zone_id

  subject_alternative_names = ["www.foodzip.com.br"]

  tags = local.common_tags
}


module "rds" {
  source = "../../../modules/rds"

  name = "${local.project}-rds"

  vpc_id        = module.networking.vpc_id
  db_subnet_ids = module.networking.private_db_subnet_ids

  instance_class  = "db.t3.micro" # free-tier
  engine_version  = "15.8"
  db_name         = "apifoodzip"
  master_username = "postgres"

  # TEMP: se precisar abrir pra testar
  # allowed_cidrs = ["SEU_IP_PUBLICO/32"]

  tags = local.common_tags
}

module "bastion" {
  source = "../../../modules/ec2/bastion"

  name = "${local.project}-ec2-bastion-rds-develop"

  vpc_id    = module.networking.vpc_id
  subnet_id = module.networking.public_subnet_ids[0]

  instance_type = "t3.micro" # free-tier EC2
  ssh_key_name  = var.ssh_key_name

  allowed_ssh_cidrs = [var.my_ip_cidr]

  tags = local.common_tags
}

module "sg_rules" {
  source = "../../../modules/sg-rules"

  rules = [
    {
      type                     = "ingress"
      description              = "Postgres from bastion"
      from_port                = 5432
      to_port                  = 5432
      protocol                 = "tcp"
      security_group_id        = module.rds.security_group_id
      source_security_group_id = module.bastion.security_group_id
    }
  ]
}
