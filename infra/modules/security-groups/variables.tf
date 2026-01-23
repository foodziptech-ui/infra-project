variable "name" { type = string }
variable "vpc_id" { type = string }

variable "tags" {
  type    = map(string)
  default = {}
}

variable "alb_ingress_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "enable_https" {
  type    = bool
  default = true
}

variable "api_container_port" {
  type    = number
  default = 8000
}

variable "frontend_container_port" {
  type    = number
  default = 80
}

variable "db_port" {
  type    = number
  default = 5432
}
