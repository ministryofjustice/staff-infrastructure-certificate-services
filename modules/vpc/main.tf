resource "aws_vpc" "pki_vpc" {
  cidr_block           = var.cidr_block
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-vpc"
    },
  )
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.pki_vpc.id

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-internet-gateway"
    },
  )
}
