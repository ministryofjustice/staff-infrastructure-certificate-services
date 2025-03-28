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

### HSM LD6 London
resource "aws_vpn_connection" "vpn_ld6" {
  tags = {
    "Name" = "${var.prefix}-pki-vpn-ld6"
  }

  vpn_gateway_id      = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id = var.cgw_hsm_ld6_id
  type                = "ipsec.1"
  static_routes_only  = true

  tunnel1_phase1_encryption_algorithms = "AES256"
  tunnel1_phase1_dh_group_numbers      = "20 | 21 | 22 | 23 | 24"
  tunnel1_phase1_integrity_algorithms  = "SHA2-256 | SHA2-384 | SHA2-512"
  tunnel1_ike_versions                 = "ikev2"

  tunnel2_phase1_encryption_algorithms = "AES256"
  tunnel2_phase1_dh_group_numbers      = "20 | 21 | 22 | 23 | 24"
  tunnel2_phase1_integrity_algorithms  = "SHA2-256 | SHA2-384 | SHA2-512"
  tunnel2_ike_versions                 = "ikev2"
}

resource "aws_vpn_connection_route" "entrust_ld6" {
  destination_cidr_block = var.ld6_remote_destination_cidr
  vpn_connection_id      = aws_vpn_connection.vpn_ld6.id
}

resource "aws_route" "ld6_vpn_route" {
  route_table_id         = var.backend_zone_route_table_id
  destination_cidr_block = var.ld6_remote_destination_cidr
  gateway_id             = aws_vpn_gateway.vpn_gateway.id
}

### HSM TSC Newbury
resource "aws_vpn_connection" "vpn_tsc" {
  tags = {
    "Name" = "${var.prefix}-pki-vpn-tsc"
  }

  vpn_gateway_id      = aws_vpn_gateway.vpn_gateway.id
  customer_gateway_id = var.cgw_hsm_tsc_id
  type                = "ipsec.1"
  static_routes_only  = true

  tunnel1_phase1_encryption_algorithms = "AES256"
  tunnel1_phase1_dh_group_numbers      = "20 | 21 | 22 | 23 | 24"
  tunnel1_phase1_integrity_algorithms  = "SHA2-256 | SHA2-384 | SHA2-512"
  tunnel1_ike_versions                 = "ikev2"

  tunnel2_phase1_encryption_algorithms = "AES256"
  tunnel2_phase1_dh_group_numbers      = "20 | 21 | 22 | 23 | 24"
  tunnel2_phase1_integrity_algorithms  = "SHA2-256 | SHA2-384 | SHA2-512"
  tunnel2_ike_versions                 = "ikev2"
}

resource "aws_vpn_connection_route" "entrust_tsc" {
  destination_cidr_block = var.tsc_remote_destination_cidr
  vpn_connection_id      = aws_vpn_connection.vpn_tsc.id
}

resource "aws_route" "tsc_vpn_route" {
  route_table_id         = var.backend_zone_route_table_id
  destination_cidr_block = var.tsc_remote_destination_cidr
  gateway_id             = aws_vpn_gateway.vpn_gateway.id
}
