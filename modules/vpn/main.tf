resource "aws_vpn_gateway" "vpn_gateway" {
  tags = {
    "Name" = "${var.prefix}-pki-vpg"
  }

  vpc_id = var.vpc_id
}


### Primary
resource "aws_vpn_connection" "main" {
  tags = {
    "Name" = "${var.prefix}-pki-vpn-primary"
  }

  vpn_gateway_id      = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id = var.cgw_hsm_primary_id
  type                = "ipsec.1"
  static_routes_only  = true
}

resource "aws_vpn_connection_route" "entrust" {
  destination_cidr_block = var.primary_remote_destination_cidr
  vpn_connection_id      = aws_vpn_connection.main.id
}

resource "aws_route" "primary_vpn_route" {
  route_table_id         = var.backend_zone_route_table_id
  destination_cidr_block = var.primary_remote_destination_cidr
  gateway_id             = aws_vpn_gateway.vpn_gateway.id
}


### Secondary
resource "aws_vpn_connection" "vpn_secondary" {
  tags = {
    "Name" = "${var.prefix}-pki-vpn-secondary"
  }

  vpn_gateway_id      = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id = var.cgw_hsm_secondary_id
  type                = "ipsec.1"
  static_routes_only  = true
}

resource "aws_vpn_connection_route" "entrust_secondary" {
  destination_cidr_block = var.secondary_remote_destination_cidr
  vpn_connection_id      = aws_vpn_connection.vpn_secondary.id
}

resource "aws_route" "secondary_vpn_route" {
  route_table_id         = var.backend_zone_route_table_id
  destination_cidr_block = var.secondary_remote_destination_cidr
  gateway_id             = aws_vpn_gateway.vpn_gateway.id
}
