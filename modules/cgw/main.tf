terraform {
  required_providers {
    aws = {}
  }
}

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

resource "aws_customer_gateway" "cgw_hsm_ld6" {
  tags = {
    "Name" = "cgw_pki_hsm_ld6"
  }

  bgp_asn    = 65000
  ip_address = var.cgw_hsm_ld6_ip
  type       = "ipsec.1"
}

resource "aws_customer_gateway" "cgw_hsm_tsc" {
  tags = {
    "Name" = "cgw_pki_hsm_tsc"
  }

  bgp_asn    = 65000
  ip_address = var.cgw_hsm_tsc_ip
  type       = "ipsec.1"
}
