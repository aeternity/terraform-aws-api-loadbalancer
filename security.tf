resource "aws_security_group" "lb" {
  name_prefix = "ae-api-lb-"
  vpc_id      = var.vpc_id

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
  security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "http_in" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "mdw_in" {
  count = var.mdw_enabled ? 1 : 0

  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "https_in" {
  count = var.enable_ssl ? 1 : 0

  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "https_mdw_in" {
  count = var.mdw_enabled && var.enable_ssl ? 1 : 0

  type              = "ingress"
  from_port         = 8443
  to_port           = 8443
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "local_external_api_in" {
  type                     = "ingress"
  from_port                = 3013
  to_port                  = 3013
  protocol                 = "TCP"
  security_group_id        = var.security_group
  source_security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "local_internal_api_in" {
  type                     = "ingress"
  from_port                = 3113
  to_port                  = 3113
  protocol                 = "TCP"
  security_group_id        = var.security_group
  source_security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "local_state_channels_api_in" {
  type                     = "ingress"
  from_port                = 3014
  to_port                  = 3014
  protocol                 = "TCP"
  security_group_id        = var.sc_security_group != "" ? var.sc_security_group : var.security_group
  source_security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "local_mdw_api_in" {
  type                     = "ingress"
  from_port                = 4000
  to_port                  = 4000
  protocol                 = "TCP"
  security_group_id        = var.mdw_security_group != "" ? var.mdw_security_group : var.security_group
  source_security_group_id = aws_security_group.lb.id
}

resource "aws_security_group_rule" "local_mdw_ws_api_in" {
  type                     = "ingress"
  from_port                = 4001
  to_port                  = 4001
  protocol                 = "TCP"
  security_group_id        = var.mdw_security_group != "" ? var.mdw_security_group : var.security_group
  source_security_group_id = aws_security_group.lb.id
}
