variable "cidr" {
  description = "VPC CIDR Block"
}

variable "azs" {
  description = "AZs list"
}

variable "public_subnets" {
  description = "Public Subnets CIDR List"
}

variable "private_subnets" {
  description = "Private Subnets CIDR List"
}

variable "environment" {
  description = "Environment name"
}