locals {
  fqdn = format("lb%s%s", var.envid, var.domain_sfx)
}

module "test_nodes_sydney" {
  source = "github.com/aeternity/terraform-aws-aenode-deploy?ref=master"
  env    = "test"

  static_nodes   = 0
  spot_nodes_min = 1
  spot_nodes_max = 2

  instance_type  = "t3.large"
  instance_types = ["t3.large"]
  ami_name       = "aeternity-ubuntu-22.04-*"

  additional_storage      = true
  additional_storage_size = 5

  asg_target_groups = module.test_gateway_lb.target_groups

  tags = {
    role  = "aenode"
    env   = "test"
    envid = var.envid
  }

  config_tags = {
    bootstrap_version = var.bootstrap_version
    vault_role        = "ae-node"
    vault_addr        = var.vault_addr
    bootstrap_config  = "secret2/aenode/config/test"
  }

  providers = {
    aws = aws.ap-southeast-2
  }
}

module "test_gateway_lb" {
  source                    = "../"
  env                       = "test"
  internal_api_enabled      = true
  state_channel_api_enabled = true
  dns_zone                  = var.dns_zone
  fqdn                      = local.fqdn
  security_group            = module.test_nodes_sydney.sg_id
  vpc_id                    = module.test_nodes_sydney.vpc_id
  subnets                   = module.test_nodes_sydney.subnets

  providers = {
    aws = aws.ap-southeast-2
  }
}
