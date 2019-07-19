locals {
  fqdn = format("%s%s", substr(var.envid, 0, 15), var.domain_sfx)
}

# TODO - change module source once it is merged to master
module "test_nodes_sydney" {
  source            = "github.com/aeternity/terraform-aws-aenode-deploy?ref=refactor"
  env               = "test"
  envid             = "${var.envid}"
  bootstrap_version = "${var.bootstrap_version}"
  vault_role        = "ae-node"
  vault_addr        = "${var.vault_addr}"

  static_nodes   = 0
  spot_nodes_min = 1
  spot_nodes_max = 2

  spot_price    = "0.15"
  instance_type = "t3.large"
  ami_name      = "aeternity-ubuntu-16.04-*"

  additional_storage      = true
  additional_storage_size = 5

  asg_target_groups = module.test_gateway_lb.target_groups

  aeternity = {
    package = "${var.package}"
  }

  providers = {
    aws = "aws.ap-southeast-2"
  }
}

module "test_gateway_lb" {
  source                    = "../"
  internal_api_enabled      = true
  state_channel_api_enabled = true
  dns_zone                  = var.dns_zone
  fqdn                      = local.fqdn
  security_group            = module.test_nodes_sydney.sg_id
  vpc_id                    = module.test_nodes_sydney.vpc_id
  subnets                   = module.test_nodes_sydney.subnets

  providers = {
    aws = "aws.ap-southeast-2"
  }
}