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

  # Allow inbound traffic from the backend zone subnet
  ingress {
    protocol   = var.tcp_protocol
    rule_no    = 100
    action     = var.allow_subnet_traffic
    cidr_block = var.private_subnet_backend_zone_cidr_block
    from_port  = var.tcp_port_range_start
    to_port    = var.tcp_port_range_end
  }

  # Allow inbound traffic from the RA zone subnet
  ingress {
    protocol   = var.tcp_protocol
    rule_no    = 101
    action     = var.allow_subnet_traffic
    cidr_block = var.private_subnet_private_ra_zone_cidr_block
    from_port  = var.tcp_port_range_start
    to_port    = var.tcp_port_range_end
  }

  # Allow inbound HTTP traffic from the public Internet
  ingress {
    protocol   = var.tcp_protocol
    rule_no    = 102
    action     = var.allow_subnet_traffic
    cidr_block = var.public_internet_cidr_block
    from_port  = var.http_port
    to_port    = var.http_port
  }

  # Allow inbound HTTPS traffic from the public Internet
  ingress {
    protocol   = var.tcp_protocol
    rule_no    = 103
    action     = var.allow_subnet_traffic
    cidr_block = var.public_internet_cidr_block
    from_port  = var.https_port
    to_port    = var.https_port
  }

  # Allow all inbound traffic from VPC
  ingress {
    protocol   = -1
    rule_no    = 200
    action     = var.allow_subnet_traffic
    cidr_block = var.cidr_block
    from_port  = 0
    to_port    = 0
  }

  # Allow inbound RDP traffic from the Donovan
  ingress {
    protocol   = var.tcp_protocol
    rule_no    = 210
    action     = var.allow_subnet_traffic
    cidr_block = var.cidr_entrust_donovan
    from_port  = var.rdp_port
    to_port    = var.rdp_port
  }

  # Allow inbound RDP traffic from MOJO Devices
  ingress {
    protocol   = var.tcp_protocol
    rule_no    = 220
    action     = var.allow_subnet_traffic
    cidr_block = var.trusted_cidr_local
    from_port  = var.rdp_port
    to_port    = var.rdp_port
  }

  # Allow inbound RDP traffic from Entrust Offices
  ingress {
    protocol   = var.tcp_protocol
    rule_no    = 230
    action     = var.allow_subnet_traffic
    cidr_block = var.cidr_entrust_offices
    from_port  = var.rdp_port
    to_port    = var.rdp_port
  }

  # Allow inbound RDP traffic from Entrust Offices backup connection
  ingress {
    protocol   = var.tcp_protocol
    rule_no    = 240
    action     = var.allow_subnet_traffic
    cidr_block = var.cidr_entrust_offices_backup
    from_port  = var.rdp_port
    to_port    = var.rdp_port
  }

  # Allow Entrust Bastion access via VPN to MoJ Bastion
  ingress {
    protocol   = var.tcp_protocol
    rule_no    = 250
    action     = var.allow_subnet_traffic
    cidr_block = var.cidr_entrust_bastions
    from_port  = var.rdp_port
    to_port    = var.rdp_port
  }

  ingress {
    protocol   = var.tcp_protocol
    rule_no    = 254
    action     = var.allow_subnet_traffic
    cidr_block = var.cidr_entrust_bastions
    from_port  = var.https_port
    to_port    = var.https_port
  }

  ingress {
    protocol   = var.tcp_protocol
    rule_no    = 256
    action     = var.allow_subnet_traffic
    cidr_block = var.cidr_entrust_bastions
    from_port  = var.splunk_port
    to_port    = var.splunk_port
  }

  ingress {
    protocol   = var.tcp_protocol
    rule_no    = 258
    action     = var.allow_subnet_traffic
    cidr_block = var.cidr_entrust_bastions
    from_port  = var.ssh_port
    to_port    = var.ssh_port
  }

  # Deny inbound RDP traffic from the public Internet
  ingress {
    protocol   = var.tcp_protocol
    rule_no    = 260
    action     = "deny"
    cidr_block = var.public_internet_cidr_block
    from_port  = var.rdp_port
    to_port    = var.rdp_port
  }

  # Allow inbound traffic on ephemeral ports the public internet
  ingress {
    protocol   = var.tcp_protocol
    rule_no    = 270
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
