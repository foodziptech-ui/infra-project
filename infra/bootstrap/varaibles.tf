variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "project" {
  type = string
}

variable "environment" {
  type = string
}

# Nome do bucket precisa ser globalmente único.
variable "state_bucket_name" {
  type = string
}

variable "dynamodb_table_name" {
  type = string
}

variable "common_tags" {
  type    = map(string)
  default = {}
}
