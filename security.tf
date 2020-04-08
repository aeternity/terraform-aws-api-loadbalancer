resource "aws_security_group" "lb" {
  name_prefix = "ae-api-lb-"
  vpc_id      = "${var.vpc_id}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group_rule" "all_out" {
  type              = "egress"
  from_port         = 0
  to_port           = 65535
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.lb.id}"
}

resource "aws_security_group_rule" "http_in" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.lb.id}"
}

resource "aws_security_group_rule" "local_external_api_in" {
  type                     = "ingress"
  from_port                = 3013
  to_port                  = 3013
  protocol                 = "TCP"
  security_group_id        = "${var.security_group}"
  source_security_group_id = "${aws_security_group.lb.id}"
}

resource "aws_security_group_rule" "local_internal_api_in" {
  type                     = "ingress"
  from_port                = 3113
  to_port                  = 3113
  protocol                 = "TCP"
  security_group_id        = "${var.security_group}"
  source_security_group_id = "${aws_security_group.lb.id}"
}

resource "aws_security_group_rule" "local_state_channels_api_in" {
  type                     = "ingress"
  from_port                = 3014
  to_port                  = 3014
  protocol                 = "TCP"
  security_group_id        = "${var.sc_security_group != "" ? var.sc_security_group : var.security_group}"
  source_security_group_id = "${aws_security_group.lb.id}"
}
