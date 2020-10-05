resource "aws_subnet" "private_subnet_private_ra_zone" {
  vpc_id                  = aws_vpc.pki_vpc.id
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

resource "aws_network_acl" "private_subnet_private_ra_zone_nacl" {
  vpc_id     = aws_vpc.pki_vpc.id
  subnet_ids = [aws_subnet.private_subnet_private_ra_zone.id]

  # Allow all inbound traffic from public subnet
  ingress {
    protocol   = var.tcp_protocol
    rule_no    = 100
    action     = var.allow_subnet_traffic
    cidr_block = var.public_subnet_cidr_block
    from_port  = var.tcp_port_range_start
    to_port    = var.tcp_port_range_end
  }

  # Allow all outbound traffic to the public subnet
  egress {
    protocol   = var.tcp_protocol
    rule_no    = 100
    action     = var.allow_subnet_traffic
    cidr_block = var.public_subnet_cidr_block
    from_port  = var.tcp_port_range_start
    to_port    = var.tcp_port_range_end
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-private-subnet-private-ra-zone-nacl"
    },
  )
}
