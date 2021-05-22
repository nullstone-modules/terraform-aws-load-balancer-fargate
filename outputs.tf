output "target_group_arn" {
  value = aws_lb_target_group.this.arn
}

output "lb_arn" {
  value = join("", aws_lb.this.*.arn)
}

output "lb_security_group_id" {
  value = join("", aws_security_group.lb.*.id)
}

output "lb_dns_name" {
  value = aws_lb.this.dns_name
}

output "lb_zone_id" {
  value = aws_lb.this.zone_id
}
