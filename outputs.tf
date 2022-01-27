output "fqdn" {
  value = aws_route53_record.lb.name
}

output "target_groups" {
  value = concat(
    [aws_lb_target_group.api_health_check.arn],
    [aws_lb_target_group.external_api.arn],
    aws_lb_target_group.internal_api.*.arn,
  )
}

output "target_groups_channels" {
  value = aws_lb_target_group.state_channels_api.*.arn
}

output "dns_name" {
  value = aws_lb.api.dns_name
}
