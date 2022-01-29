resource "aws_lb" "api" {
  name_prefix        = "apilb-"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
  subnets            = var.subnets

  enable_deletion_protection = false

  tags = {
    env = var.env
  }
}

resource "aws_lb_target_group" "api_health_check" {
  name_prefix = "hlt-"
  port        = 8080
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    path                = "/healthz"
    port                = 8080
    interval            = 30
  }

  tags = {
    env = var.env
  }
}

resource "aws_lb_target_group" "external_api" {
  name_prefix = "ext-"
  port        = 3013
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    path                = "/healthz"
    port                = 8080
    interval            = 30
  }

  tags = {
    env = var.env
  }
}

resource "aws_lb_target_group" "internal_api" {
  count       = var.internal_api_enabled || var.dry_run_enabled ? 1 : 0
  name_prefix = "int-"
  port        = 3113
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    path                = "/healthz"
    port                = 8080
    interval            = 30
  }

  tags = {
    env = var.env
  }
}

resource "aws_lb_target_group" "state_channels_api" {
  count       = var.state_channel_api_enabled ? 1 : 0
  name_prefix = "sc-"
  port        = 3014
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    path                = "/healthz"
    port                = 8080
    interval            = 30
  }

  tags = {
    env = var.env
  }
}

resource "aws_alb_listener" "api" {
  load_balancer_arn = aws_lb.api.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.external_api.arn
  }
}

resource "aws_lb_listener_rule" "health_check" {
  listener_arn = aws_alb_listener.api.arn

  condition {
    path-pattern {
      values = ["/healthz"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api_health_check.arn
  }
}

resource "aws_lb_listener_rule" "internal_api" {
  count        = var.internal_api_enabled ? 1 : 0
  listener_arn = aws_alb_listener.api.arn

  condition {
    path-pattern {
      values = ["/v?/debug/*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internal_api.0.arn
  }
}

resource "aws_lb_listener_rule" "dry_run" {
  count        = var.dry_run_enabled ? 1 : 0
  listener_arn = aws_alb_listener.api.arn

  condition {
    path-pattern {
      values = ["/v?/debug/transactions/dry-run"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.internal_api.0.arn
  }
}

resource "aws_lb_listener_rule" "state_channels_api" {
  count        = var.state_channel_api_enabled ? 1 : 0
  listener_arn = aws_alb_listener.api.arn

  condition {
    path-pattern {
      values = ["/channel"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.state_channels_api.0.arn
  }
}
