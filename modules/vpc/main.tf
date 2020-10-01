module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.44.0"
  name    = "${var.prefix}-vpc"

  cidr               = var.cidr_block
  enable_nat_gateway = true

  azs = [
    "${var.region}a",
    "${var.region}b",
    "${var.region}c"
  ]

  private_subnets = var.private_subnet_cidr_blocks

  public_subnets = [var.public_subnet_cidr_block]
}
