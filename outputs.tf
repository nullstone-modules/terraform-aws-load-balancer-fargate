output "target_group_arn" {
  value = aws_lb_target_group.this.arn
}

output "lb_arn" {
  value = join("", aws_lb.this.*.arn)
}

output "lb_security_group_id" {
  value = join("", aws_security_group.lb.*.id)
}
