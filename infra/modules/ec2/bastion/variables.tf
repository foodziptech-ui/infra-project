variable "name" { type = string }

variable "vpc_id" { type = string }
variable "subnet_id" { type = string } # subnet pública

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "ssh_key_name" { type = string }

variable "allowed_ssh_cidrs" {
  type    = list(string)
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
