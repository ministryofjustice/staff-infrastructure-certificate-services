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

  tags = var.tags
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = var.public_subnet_cidr_block
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = true

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-public-subnet"
    },
  )
}

resource "aws_subnet" "private_subnet_backend_zone" {
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = var.private_subnet_backend_zone_cidr_block
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-private-backend-zone-subnet"
    },
  )
}

resource "aws_subnet" "private_subnet_private_ra_zone" {
  vpc_id                  = module.vpc.vpc_id
  cidr_block              = var.private_subnet_private_ra_zone_cidr_block
  availability_zone       = "${var.region}a"
  map_public_ip_on_launch = false

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-private-ra-zone-subnet"
    },
  )
}
