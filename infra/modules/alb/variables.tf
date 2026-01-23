variable "name" { type = string }
variable "vpc_id" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "alb_sg_id" { type = string }

variable "certificate_arn" { type = string }

variable "api_target_port" {
  type    = number
  default = 8000
}

variable "frontend_target_port" {
  type    = number
  default = 80
}

variable "health_check_path_api" {
  type    = string
  default = "/api/health"
}

variable "health_check_path_frontend" {
  type    = string
  default = "/"
}

variable "tags" {
  type    = map(string)
  default = {}
}
