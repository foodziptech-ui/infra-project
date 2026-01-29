output "rule_ids" {
  value = [for r in aws_security_group_rule.this : r.id]
}
