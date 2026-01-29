variable "name" { type = string }

variable "vpc_id" { type = string }
variable "db_subnet_ids" { type = list(string) }

variable "engine" {
  type    = string
  default = "postgres"
}

variable "engine_version" {
  type    = string
  default = "15.8"
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro" # free-tier (t3.micro ou t4g.micro)
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "db_name" { type = string }

variable "master_username" {
  type    = string
  default = "postgres"
}

variable "port" {
  type    = number
  default = 5432
}

# Para começar simples: liberar por CIDR (ex.: sua VPN/bastion).
# Depois a gente troca para permitir apenas o SG do ECS/EC2.
variable "allowed_cidrs" {
  type    = list(string)
  default = []
}

variable "publicly_accessible" {
  type    = bool
  default = false
}

variable "multi_az" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}
