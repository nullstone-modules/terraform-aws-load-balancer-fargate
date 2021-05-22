resource "aws_security_group" "lb" {
  name   = "${var.name}/lb"
  vpc_id = var.network.vpc_id
  tags   = merge(var.tags, { Name = "${var.name}/lb" })
}

resource "aws_security_group_rule" "lb-https-from-world" {
  security_group_id = aws_security_group.lb.id
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 443
  to_port           = 443

  count = var.https.enabled ? 1 : 0
}

// This rule is always enabled; when we are listening on https, we still want to force http to https through redirect
resource "aws_security_group_rule" "lb-http-from-world" {
  security_group_id = aws_security_group.lb.id
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
  protocol          = "tcp"
  from_port         = 80
  to_port           = 80
}

resource "aws_security_group_rule" "lb-http-to-service" {
  security_group_id        = aws_security_group.lb.id
  source_security_group_id = var.service.security_group_id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = var.service.port
  to_port                  = var.service.port
}

resource "aws_security_group_rule" "service-http-from-lb" {
  security_group_id        = var.service.security_group_id
  source_security_group_id = aws_security_group.lb.id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = var.service.port
  to_port                  = var.service.port
}
