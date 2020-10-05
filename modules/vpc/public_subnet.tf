resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.pki_vpc.id
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

resource "aws_network_acl" "public_subnet_nacl" {
  vpc_id     = aws_vpc.pki_vpc.id
  subnet_ids = [aws_subnet.public_subnet.id]

  # Allow inbound RDP traffic from the public Internet
  ingress {
    protocol   = var.tcp_protocol
    rule_no    = 100
    action     = var.allow_subnet_traffic
    cidr_block = var.public_internet_cidr_block
    from_port  = var.rdp_port
    to_port    = var.rdp_port
  }

  # Allow inbound traffic from the backend zone subnet
  ingress {
    protocol   = var.tcp_protocol
    rule_no    = 101
    action     = var.allow_subnet_traffic
    cidr_block = var.private_subnet_backend_zone_cidr_block
    from_port  = var.tcp_port_range_start
    to_port    = var.tcp_port_range_end
  }

  # Allow inbound traffic from the RA zone subnet
  ingress {
    protocol   = var.tcp_protocol
    rule_no    = 102
    action     = var.allow_subnet_traffic
    cidr_block = var.private_subnet_private_ra_zone_cidr_block
    from_port  = var.tcp_port_range_start
    to_port    = var.tcp_port_range_end
  }

  # TODO: remove this?
  # Allow inbound HTTP traffic from the public Internet
  ingress {
    protocol   = var.tcp_protocol
    rule_no    = 103
    action     = var.allow_subnet_traffic
    cidr_block = var.public_internet_cidr_block
    from_port  = var.http_port
    to_port    = var.http_port
  }

  # TODO: remove this?
  # Allow inbound HTTPS traffic from the public Internet
  ingress {
    protocol   = var.tcp_protocol
    rule_no    = 104
    action     = var.allow_subnet_traffic
    cidr_block = var.public_internet_cidr_block
    from_port  = var.https_port
    to_port    = var.https_port
  }

  # TODO: talk to Rich about this
  # Maybe we should have a separate subnet for this, so we don't open this bastion up
  # Although the Bastion will eventually be decommissioned?
  # Allow inbound traffic on ephemeral ports - this allows repsonses to HTTP requests from private-subnet instances
  ingress {
    protocol   = var.tcp_protocol
    rule_no    = 105
    action     = var.allow_subnet_traffic
    cidr_block = var.public_internet_cidr_block
    from_port  = var.ephemeral_port_start
    to_port    = var.ephemeral_port_end
  }

  # Allow all outbound traffic to the public Internet
  egress {
    protocol   = var.tcp_protocol
    rule_no    = 100
    action     = var.allow_subnet_traffic
    cidr_block = var.public_internet_cidr_block
    from_port  = var.tcp_port_range_start
    to_port    = var.tcp_port_range_end
  }

  # Allow outbound traffic to the backend zone subnet
  egress {
    protocol   = var.tcp_protocol
    rule_no    = 101
    action     = var.allow_subnet_traffic
    cidr_block = var.private_subnet_backend_zone_cidr_block
    from_port  = var.tcp_port_range_start
    to_port    = var.tcp_port_range_end
  }

  # Allow outbound traffic to the RA zone subnet
  egress {
    protocol   = var.tcp_protocol
    rule_no    = 102
    action     = var.allow_subnet_traffic
    cidr_block = var.private_subnet_private_ra_zone_cidr_block
    from_port  = var.tcp_port_range_start
    to_port    = var.tcp_port_range_end
  }

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-public-subnet-nacl"
    },
  )
}

resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = aws_vpc.pki_vpc.id

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-public-subnet-route-table"
    },
  )
}

resource "aws_route" "public_subnet_internet_access_route_table_rule" {
  route_table_id         = aws_route_table.public_subnet_route_table.id
  destination_cidr_block = var.public_internet_cidr_block
  gateway_id             = aws_internet_gateway.internet_gateway.id
}

resource "aws_route_table_association" "public_subnet_route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_subnet_route_table.id
}

resource "aws_eip" "pki_nat_gateway_eip" {
  vpc = true

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-backend-zone-elastic-ip"
    },
  )
}
resource "aws_nat_gateway" "pki_nat_gateway" {
  allocation_id = aws_eip.pki_nat_gateway_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = merge(
    var.tags,
    {
      Name = "${var.prefix}-nat-gateway"
    },
  )
}
