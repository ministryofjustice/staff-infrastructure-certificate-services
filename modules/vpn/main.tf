resource "aws_vpn_gateway" "vpn_gateway" {
  tags = {
    "Name" = "${var.prefix}-pki-vpg"
  }

  vpc_id = var.vpc_id
}


## Primary

resource "aws_customer_gateway" "customer_gateway" {
  tags = {
    "Name" = "${var.prefix}-pki-cgw-primary"
  }

  bgp_asn    = 65000
  ip_address = var.customer_gateway_primary_ip
  type       = "ipsec.1"
}

resource "aws_vpn_connection" "main" {
  tags = {
    "Name" = "${var.prefix}-pki-vpn-primary"
  }

  vpn_gateway_id      = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id = aws_customer_gateway.customer_gateway.id
  type                = "ipsec.1"
  static_routes_only  = true
}

resource "aws_vpn_connection_route" "entrust" {
  destination_cidr_block = var.primary_remote_destination_cidr
  vpn_connection_id      = aws_vpn_connection.main.id
}

resource "aws_vpn_connection_route" "internal" {
  destination_cidr_block = var.primary_internal_cidr
  vpn_connection_id      = aws_vpn_connection.main.id
}

resource "aws_route" "primary_vpn_route" {
  route_table_id         = var.backend_zone_route_table_id
  destination_cidr_block = var.primary_remote_destination_cidr
  gateway_id             = aws_vpn_gateway.vpn_gateway.id
}






### secondary

resource "aws_customer_gateway" "customer_gateway_secondary" {
  tags = {
    "Name" = "${var.prefix}-pki-cgw-secondary"
  }

  bgp_asn    = 65000
  ip_address = var.customer_gateway_secondary_ip
  type       = "ipsec.1"
}

resource "aws_vpn_connection" "vpn_secondary" {
  tags = {
    "Name" = "${var.prefix}-pki-vpn-secondary"
  }

  vpn_gateway_id      = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id = aws_customer_gateway.customer_gateway_secondary.id
  type                = "ipsec.1"
  static_routes_only  = true
}

resource "aws_vpn_connection_route" "entrust_secondary" {
  destination_cidr_block = var.secondary_remote_destination_cidr
  vpn_connection_id      = aws_vpn_connection.vpn_secondary.id
}

resource "aws_vpn_connection_route" "internal_secondary" {
  destination_cidr_block = var.seondary_internal_cidr
  vpn_connection_id      = aws_vpn_connection.vpn_secondary.id
}

resource "aws_route" "secondary_vpn_route" {
  route_table_id         = var.backend_zone_route_table_id
  destination_cidr_block = var.secondary_remote_destination_cidr
  gateway_id             = aws_vpn_gateway.vpn_gateway.id
}
