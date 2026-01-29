variable "rules" {
  description = "Lista de regras SG->SG"
  type = list(object({
    type                     = string   # ingress/egress
    description              = string
    from_port                = number
    to_port                  = number
    protocol                 = string
    security_group_id        = string
    source_security_group_id = string
  }))
}
