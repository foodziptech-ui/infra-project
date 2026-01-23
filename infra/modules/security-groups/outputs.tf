output "alb_sg_id" {
  value = aws_security_group.alb.id
}

output "ecs_api_sg_id" {
  value = aws_security_group.ecs_api.id
}

output "ecs_frontend_sg_id" {
  value = aws_security_group.ecs_frontend.id
}

output "rds_sg_id" {
  value = aws_security_group.rds.id
}
