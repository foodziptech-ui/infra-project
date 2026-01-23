variable "name" { type = string }
variable "vpc_cidr" { type = string }

variable "azs" {
  type = list(string)
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "private_app_subnet_cidrs" {
  type = list(string)
}

variable "private_db_subnet_cidrs" {
  type = list(string)
}

variable "enable_nat_gateway" {
  type    = bool
  default = true
}

variable "single_nat_gateway" {
  type    = bool
  default = false
  # false = 1 NAT por AZ (recomendado)
  # true  = 1 NAT só (mais barato, menos HA)
}

variable "tags" {
  type    = map(string)
  default = {}
}
