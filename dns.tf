data "aws_region" "current" {}

resource "aws_route53_health_check" "lb" {
  count             = var.dns_health_check ? 1 : 0
  fqdn              = aws_lb.api.dns_name
  port              = 80
  type              = "HTTP"
  resource_path     = "/healthz"
  measure_latency   = false
  failure_threshold = "4"
  request_interval  = 30

  tags = {
    env = var.env
  }
}

resource "aws_route53_record" "lb" {
  zone_id = var.dns_zone
  name    = var.fqdn
  type    = "A"

  health_check_id = var.dns_health_check ? aws_route53_health_check.lb[0].id : null
  set_identifier  = "${var.fqdn}-${data.aws_region.current.name}"

  alias {
    name                   = aws_lb.api.dns_name
    zone_id                = aws_lb.api.zone_id
    evaluate_target_health = var.dns_health_check
  }

  latency_routing_policy {
    region = data.aws_region.current.name
  }
}
