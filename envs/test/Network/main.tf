module "vpc" {
  source = "../../../modules/vpc"

  environment     = var.environment
  cidr            = var.cidr
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets

  enable_dhcp_options     = true
  enable_dns_hostnames    = true
  enable_nat_gateway      = true
  one_nat_gateway_per_az  = false
  single_nat_gateway      = true

/*  tags = {
    Environment = var.environment
    Created-By  = var.created-by
  }
*/
}
