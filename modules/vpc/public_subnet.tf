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

  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.public_internet_cidr_block
    from_port  = var.rdp_port
    to_port    = var.rdp_port
  }

  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.public_internet_cidr_block
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
