resource "aws_customer_gateway" "cgw_hsm_primary" {
  tags = {
    "Name" = "cgw_pki_hsm_primary"
  }

  bgp_asn    = 65000
  ip_address = var.cgw_hsm_primary_ip
  type       = "ipsec.1"
}

resource "aws_customer_gateway" "cgw_hsm_secondary" {
  tags = {
    "Name" = "cgw_pki_hsm_secondary"
  }

  bgp_asn    = 65000
  ip_address = var.cgw_hsm_secondary_ip
  type       = "ipsec.1"
}