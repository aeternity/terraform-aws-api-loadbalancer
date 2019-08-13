data "aws_region" "current" {}

resource "aws_route53_health_check" "lb" {
  fqdn              = "${aws_lb.api.dns_name}"
  port              = 80
  type              = "HTTP"
  resource_path     = "/healthz"
  measure_latency   = false
  failure_threshold = "4"
  request_interval  = 30

  tags = {
    env = "${var.env}"
  }
}

resource "aws_route53_record" "lb" {
  zone_id = "${var.dns_zone}"
  name    = "${var.fqdn}"
  type    = "A"

  health_check_id = "${aws_route53_health_check.lb.id}"
  set_identifier  = "${var.fqdn}-${data.aws_region.current.name}"

  alias {
    name                   = "${aws_lb.api.dns_name}"
    zone_id                = "${aws_lb.api.zone_id}"
    evaluate_target_health = true
  }

  latency_routing_policy {
    region = "${data.aws_region.current.name}"
  }
}
