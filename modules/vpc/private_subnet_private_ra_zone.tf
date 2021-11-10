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

resource "aws_route_table" "ra_zone_route_table" {
  vpc_id = aws_vpc.pki_vpc.id

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-ra-zone-route-table"
    },
  )
}

resource "aws_route" "ra_zone_route" {
  route_table_id         = aws_route_table.ra_zone_route_table.id
  destination_cidr_block = var.public_internet_cidr_block
  nat_gateway_id         = aws_nat_gateway.pki_nat_gateway.id
}

resource "aws_route_table_association" "ra_zone_route_table_association" {
  subnet_id      = aws_subnet.private_subnet_private_ra_zone.id
  route_table_id = aws_route_table.ra_zone_route_table.id
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

  # Allow all inbound traffic from private backend zone subnet
  ingress {
    protocol   = var.tcp_protocol
    rule_no    = 101
    action     = var.allow_subnet_traffic
    cidr_block = var.private_subnet_backend_zone_cidr_block
    from_port  = var.tcp_port_range_start
    to_port    = var.tcp_port_range_end
  }

  # Allow all inbound traffic from the public internet
  ingress {
    protocol   = var.tcp_protocol
    rule_no    = 102
    action     = var.allow_subnet_traffic
    cidr_block = var.public_internet_cidr_block
    from_port  = var.tcp_port_range_start
    to_port    = var.tcp_port_range_end
  }

  # Allow all inbound traffic from VPC
  ingress {
    protocol   = -1
    rule_no    = 202
    action     = var.allow_subnet_traffic
    cidr_block = var.cidr_block
    from_port  = 0
    to_port    = 0
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

  # Allow all outbound traffic to the private backend zone subnet
  egress {
    protocol   = var.tcp_protocol
    rule_no    = 101
    action     = var.allow_subnet_traffic
    cidr_block = var.private_subnet_backend_zone_cidr_block
    from_port  = var.tcp_port_range_start
    to_port    = var.tcp_port_range_end
  }

  # Allow all outbound traffic to the public internet
  egress {
    protocol   = var.tcp_protocol
    rule_no    = 102
    action     = var.allow_subnet_traffic
    cidr_block = var.public_internet_cidr_block
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
