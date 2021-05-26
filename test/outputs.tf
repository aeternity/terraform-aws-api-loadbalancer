output "fqdn" {
  value = module.test_gateway_lb.fqdn
}

output "target_groups" {
  value = module.test_gateway_lb.target_groups
}
