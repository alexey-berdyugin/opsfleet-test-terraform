variable environment {}

variable cidr {
  type = string
}
variable azs {
  type = list(string)
}
variable public_subnets {
  type = list(string)
}
variable private_subnets {
  type = list(string)
}

variable "enable_dns_hostnames" {
  type = bool
  default = false
}

variable "enable_nat_gateway" {
  type = bool
  default = true
}

variable "one_nat_gateway_per_az" {
  type = bool
  default = true
}

variable "single_nat_gateway" {
  type = bool
  default = false
}

variable enable_dhcp_options {
  type    = bool
  default = false
}

variable dhcp_options_domain_name {
  type    = string
  default = ""
}

variable dhcp_options_domain_name_servers {
  type    = list(string)
  default = ["AmazonProvidedDNS"]
}
