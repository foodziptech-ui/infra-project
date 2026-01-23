# ---------------- ALB ----------------
resource "aws_security_group" "alb" {
  name        = "${var.name}-alb-sg"
  description = "ALB security group"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name}-alb-sg"
  })
}

# HTTP
resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = var.alb_ingress_cidrs[0]
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

# Se você quiser suportar múltiplos CIDRs, criaremos um for_each.
# Por enquanto mantive simples. Se você quiser lista, eu adapto já.

# HTTPS (opcional)
resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  count             = var.enable_https ? 1 : 0
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = var.alb_ingress_cidrs[0]
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

# Egress aberto (ALB precisa falar com targets)
resource "aws_vpc_security_group_egress_rule" "alb_all" {
  security_group_id = aws_security_group.alb.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# ---------------- ECS API ----------------
resource "aws_security_group" "ecs_api" {
  name        = "${var.name}-ecs-api-sg"
  description = "ECS API security group"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name}-ecs-api-sg"
  })
}

# API recebe SOMENTE do ALB
resource "aws_vpc_security_group_ingress_rule" "ecs_api_from_alb" {
  security_group_id            = aws_security_group.ecs_api.id
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = var.api_container_port
  to_port                      = var.api_container_port
  ip_protocol                  = "tcp"
}

# Egress aberto (pra chamar RDS, S3, etc via NAT)
resource "aws_vpc_security_group_egress_rule" "ecs_api_all" {
  security_group_id = aws_security_group.ecs_api.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# ---------------- ECS FRONTEND ----------------
resource "aws_security_group" "ecs_frontend" {
  name        = "${var.name}-ecs-frontend-sg"
  description = "ECS Frontend security group"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name}-ecs-frontend-sg"
  })
}

# Frontend recebe SOMENTE do ALB
resource "aws_vpc_security_group_ingress_rule" "ecs_frontend_from_alb" {
  security_group_id            = aws_security_group.ecs_frontend.id
  referenced_security_group_id = aws_security_group.alb.id
  from_port                    = var.frontend_container_port
  to_port                      = var.frontend_container_port
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_egress_rule" "ecs_frontend_all" {
  security_group_id = aws_security_group.ecs_frontend.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# ---------------- RDS ----------------
resource "aws_security_group" "rds" {
  name        = "${var.name}-rds-sg"
  description = "RDS security group"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name = "${var.name}-rds-sg"
  })
}

# RDS recebe SOMENTE da API (normalmente frontend não fala com DB)
resource "aws_vpc_security_group_ingress_rule" "rds_from_api" {
  security_group_id            = aws_security_group.rds.id
  referenced_security_group_id = aws_security_group.ecs_api.id
  from_port                    = var.db_port
  to_port                      = var.db_port
  ip_protocol                  = "tcp"
}

# Egress do RDS pode ficar aberto (padrão), ou restrito.
resource "aws_vpc_security_group_egress_rule" "rds_all" {
  security_group_id = aws_security_group.rds.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
