resource "aws_security_group_rule" "this" {
  for_each = {
    for idx, r in var.rules : idx => r
  }

  type                     = each.value.type
  description              = each.value.description
  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  security_group_id        = each.value.security_group_id
  source_security_group_id = each.value.source_security_group_id
}
