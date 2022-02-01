variable "dns_zone" {
  default = "Z2J3KVPABDNIL1"
}

variable "domain_sfx" {
  default = ".ops.aeternity.com"
}

variable "envid" {
  description = "Unique test environment identifier to prevent collisions."
}

variable "vault_addr" {
  description = "Vault server URL address"
}

variable "bootstrap_version" {
  default = "bump-dataog-agent"
}

variable "package" {
  default = "https://releases.aeternity.io/aeternity-latest-ubuntu-x86_64.tar.gz"

}
