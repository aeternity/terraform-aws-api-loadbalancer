output "fqdn" {
  value = "${aws_route53_record.lb.name}"
}

output target_groups {
  value = concat(
    list(aws_lb_target_group.api_health_check.arn),
    list(aws_lb_target_group.external_api.arn),
    aws_lb_target_group.internal_api.*.arn,
    aws_lb_target_group.state_channels_api.*.arn
  )
}
