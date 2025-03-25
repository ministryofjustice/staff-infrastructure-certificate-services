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
  destination_cidr_block = var.secondary_remote_destination_cidr //192.168.30.0/24
  vpn_connection_id      = aws_vpn_connection.vpn_secondary.id
}

resource "aws_route" "secondary_vpn_route" {
  route_table_id         = var.backend_zone_route_table_id
  destination_cidr_block = var.secondary_remote_destination_cidr //192.168.30.0/24
  gateway_id             = aws_vpn_gateway.vpn_gateway.id
}

### HSM LD6 London
resource "aws_vpn_connection" "vpn_ld6" {
  tags = {
    "Name" = "${var.prefix}-pki-vpn-ld6"
  }

  vpn_gateway_id      = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id = var.cgw_hsm_ld6_id // 88.84.131.132 
  type                = "ipsec.1"
  static_routes_only  = true
}

resource "aws_vpn_connection_route" "entrust" {
  destination_cidr_block = var.ld6_remote_destination_cidr //[192.168.31.0/24, 192.168.3.0/24]
  vpn_connection_id      = aws_vpn_connection.vpn_ld6.id
}

resource "aws_route" "ld6_vpn_route" {
  route_table_id         = var.backend_zone_route_table_id
  destination_cidr_block = var.ld6_remote_destination_cidr //[192.168.31.0/24, 192.168.3.0/24]
  gateway_id             = aws_vpn_gateway.vpn_gateway.id
}

### HSM TSC Newbury
resource "aws_vpn_connection" "vpn_tsc" {
  tags = {
    "Name" = "${var.prefix}-pki-vpn-tsc"
  }

  vpn_gateway_id      = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id = var.cgw_hsm_tsc_id // 213.1.236.32 // Rename LD6 and TSC
  type                = "ipsec.1"
  static_routes_only  = true
}

resource "aws_vpn_connection_route" "entrust" {
  destination_cidr_block = var.tsc_remote_destination_cidr //[192.168.41.0/24, 192.168.13.0/24]
  vpn_connection_id      = aws_vpn_connection.vpn_tsc.id
}

resource "aws_route" "tsc_vpn_route" {
  route_table_id         = var.backend_zone_route_table_id
  destination_cidr_block = var.tsc_remote_destination_cidr //[192.168.41.0/24, 192.168.13.0/24]
  gateway_id             = aws_vpn_gateway.vpn_gateway.id
}
