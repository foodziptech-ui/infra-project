output "vpc_id" {
  value = module.networking.vpc_id
}

output "private_app_subnet_ids" {
  value = module.networking.private_app_subnet_ids
}

output "private_db_subnet_ids" {
  value = module.networking.private_db_subnet_ids
}

### Security Groups ###
output "alb_sg_id" {
  value = module.security_groups.alb_sg_id
}

output "ecs_api_sg_id" {
  value = module.security_groups.ecs_api_sg_id
}

output "ecs_frontend_sg_id" {
  value = module.security_groups.ecs_frontend_sg_id
}

output "rds_sg_id" {
  value = module.security_groups.rds_sg_id
}

output "acm_certificate_arn" {
  value = module.acm.certificate_arn
}
