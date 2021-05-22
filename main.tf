resource "aws_lb" "this" {
  name               = var.name
  internal           = false
  load_balancer_type = "application"
  subnets            = var.network.subnet_ids
  security_groups    = [aws_security_group.lb[count.index].id]
  enable_http2       = true
  ip_address_type    = "ipv4"
  tags               = var.tags

  access_logs {
    bucket  = module.logs_bucket.bucket_id
    enabled = true
  }
}

resource "aws_lb_listener" "http" {
  count = var.https.enabled ? 0 : 1

  load_balancer_arn = aws_lb.this[count.index].arn
  protocol          = "HTTP"
  port              = 80

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_listener" "http-redirect-to-https" {
  count = var.https.enabled ? 1 : 0

  load_balancer_arn = aws_lb.this[count.index].arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https" {
  count = var.https.enabled ? 1 : 0

  load_balancer_arn = aws_lb.this[count.index].arn
  protocol          = "HTTPS"
  port              = 443
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = var.https.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_target_group" "this" {
  name                 = var.name
  port                 = var.service.port
  protocol             = "HTTP"
  target_type          = "ip"
  vpc_id               = var.network.vpc_id
  deregistration_delay = 30
  tags                 = var.tags

  health_check {
    // TODO: Allowing any HTTP response to imply healthy, expand later
    matcher = "200-499"
  }
}
