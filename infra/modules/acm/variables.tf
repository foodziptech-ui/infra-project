variable "domain_name" { type = string }
variable "hosted_zone_id" { type = string }
variable "subject_alternative_names" {
  type    = list(string)
  default = []
}
variable "tags" {
  type    = map(string)
  default = {}
}
