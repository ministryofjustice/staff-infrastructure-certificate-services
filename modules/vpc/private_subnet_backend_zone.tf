resource "aws_subnet" "private_subnet_backend_zone" {
  vpc_id                  = aws_vpc.pki_vpc.id
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

resource "aws_route_table" "backend_zone_route_table" {
  vpc_id = aws_vpc.pki_vpc.id

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-backend-zone-route-table"
    },
  )
}

resource "aws_route" "backend_zone_route" {
  route_table_id         = aws_route_table.backend_zone_route_table.id
  destination_cidr_block = var.public_internet_cidr_block
  nat_gateway_id         = aws_nat_gateway.pki_nat_gateway.id
}

resource "aws_route" "ost_peer_route" {
  route_table_id            = aws_route_table.backend_zone_route_table.id
  destination_cidr_block    = var.ost_cidr_block
  vpc_peering_connection_id = var.ost_peering_id
}

resource "aws_route" "gp_tgw_route_backend_zone" {
  route_table_id         = aws_route_table.backend_zone_route_table.id
  destination_cidr_block = var.gp_client_prod_cidr_block
  transit_gateway_id     = var.mojo_prod_tgw_id
}

resource "aws_route_table_association" "backend_zone_route_table_association" {
  subnet_id      = aws_subnet.private_subnet_backend_zone.id
  route_table_id = aws_route_table.backend_zone_route_table.id
}

resource "aws_network_acl" "private_subnet_backend_zone_nacl" {
  vpc_id     = aws_vpc.pki_vpc.id
  subnet_ids = [aws_subnet.private_subnet_backend_zone.id]

  # Allow all inbound traffic from public subnet
  ingress {
    protocol   = var.tcp_protocol
    rule_no    = 100
    action     = var.allow_subnet_traffic
    cidr_block = var.public_subnet_cidr_block
    from_port  = var.tcp_port_range_start
    to_port    = var.tcp_port_range_end
  }

  # Allow all inbound traffic from private RA zone subnet
  ingress {
    protocol   = var.tcp_protocol
    rule_no    = 101
    action     = var.allow_subnet_traffic
    cidr_block = var.private_subnet_private_ra_zone_cidr_block
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

  # Allow all inbound traffic from HSM Primary
  ingress {
    protocol   = -1
    rule_no    = 203
    action     = var.allow_subnet_traffic
    cidr_block = var.ip_hsm_primary
    from_port  = 0
    to_port    = 0
  }

  # Allow all inbound traffic from HSM Secondary
  ingress {
    protocol   = -1
    rule_no    = 204
    action     = var.allow_subnet_traffic
    cidr_block = var.ip_hsm_secondary
    from_port  = 0
    to_port    = 0
  }

  # Allow all inbound traffic from HSM LD6 London
  ingress {
    protocol   = -1
    rule_no    = 205
    action     = var.allow_subnet_traffic
    cidr_block = var.ip_hsm_ld6
    from_port  = 0
    to_port    = 0
  }

  # Allow all inbound traffic from HSM TSC Newbury
  ingress {
    protocol   = -1
    rule_no    = 206
    action     = var.allow_subnet_traffic
    cidr_block = var.ip_hsm_tsc
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

  # Allow all outbound traffic to the private RA zone subnet
  egress {
    protocol   = var.tcp_protocol
    rule_no    = 101
    action     = var.allow_subnet_traffic
    cidr_block = var.private_subnet_private_ra_zone_cidr_block
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
      Name = "${var.prefix}-private-subnet-backend-zone-nacl"
    },
  )
}
