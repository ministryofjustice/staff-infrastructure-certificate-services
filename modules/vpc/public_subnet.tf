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
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.public_internet_cidr_block
    from_port  = var.rdp_port
    to_port    = var.rdp_port
  }

  # Allow inbound traffic from the backend zone subnet
  ingress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = var.private_subnet_backend_zone_cidr_block
    from_port  = var.tcp_port_range_start
    to_port    = var.tcp_port_range_end
  }

  # Allow inbound traffic from the RA zone subnet
  ingress {
    protocol   = "tcp"
    rule_no    = 102
    action     = "allow"
    cidr_block = var.private_subnet_private_ra_zone_cidr_block
    from_port  = var.tcp_port_range_start
    to_port    = var.tcp_port_range_end
  }

  # Allow all outbound traffic to the public Internet
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.public_internet_cidr_block
    from_port  = var.tcp_port_range_start
    to_port    = var.tcp_port_range_end
  }

  # Allow outbound traffic to the backend zone subnet
  egress {
    protocol   = "tcp"
    rule_no    = 101
    action     = "allow"
    cidr_block = var.private_subnet_backend_zone_cidr_block
    from_port  = var.tcp_port_range_start
    to_port    = var.tcp_port_range_end
  }

  # Allow outbound traffic to the RA zone subnet
  egress {
    protocol   = "tcp"
    rule_no    = 102
    action     = "allow"
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

resource "aws_route_table_association" "public_subnet_route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_subnet_route_table.id
}

resource "aws_route" "public_subnet_internet_access_route_table_rule" {
  route_table_id         = aws_route_table.public_subnet_route_table.id
  destination_cidr_block = var.public_internet_cidr_block
  gateway_id             = aws_internet_gateway.internet_gateway.id
}
