variable "vpc_id" {
  description = "VPC of the nodes fleet"
}

variable "subnets" {
  description = "Subnets of the nodes fleet"
}

variable "security_group" {
  description = "Security group to allow load balancer traffic to"
}

variable "sc_security_group" {
  description = "State channels security group to allow load balancer traffic to"
  type        = string
  default     = ""
}

variable "fqdn" {
  description = "Fully qualified domain name of the load balancer. Used for latency routing."
}

variable "dns_zone" {
  description = "DNS zone (AWS) of the FQDN domain"
}

variable "internal_api_enabled" {
  description = "Enable internal API listener and allow traffic in security group. Includes dry-run."
  type        = bool
  default     = false
}

variable "dry_run_enabled" {
  description = "Enable dry-run internal API endpoint only and allow traffic in security group"
  type        = bool
  default     = false
}

variable "state_channel_api_enabled" {
  description = "Enable state channels websockets API listener and allow traffic in security group"
  type        = bool
  default     = false
}

variable "env" {
  description = "Used for tagging purposes only, thus the default for BC"
  type        = string
  default     = "unknown"
}
