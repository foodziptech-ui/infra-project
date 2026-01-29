variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}


variable "ssh_key_name" {
  type        = string
  default     = "foodzipkeyserver"
}

variable "my_ip_cidr" {
  type        = string
  default     = "177.37.143.71/32"
}
