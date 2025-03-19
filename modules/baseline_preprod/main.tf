terraform {
  required_providers {
    aws = {}
  }
}

data "aws_caller_identity" "current" {}

module "pki_vpc" {
  source = ".././vpc"

  region                                    = var.region_id
  cidr_block                                = local.cidr_block_vpc
  public_subnet_cidr_block                  = local.cidr_public_subnet
  private_subnet_backend_zone_cidr_block    = local.cidr_private_backend_zone
  private_subnet_private_ra_zone_cidr_block = local.cidr_private_ra_zone
  public_internet_cidr_block                = local.public_internet_cidr_block
  ssh_port                                  = local.ssh_port
  rdp_port                                  = local.rdp_port
  tcp_port_range_start                      = local.tcp_port_range_start
  tcp_port_range_end                        = local.tcp_port_range_end
  http_port                                 = local.http_port
  https_port                                = local.https_port
  ephemeral_port_start                      = local.ephemeral_port_start
  ephemeral_port_end                        = local.ephemeral_port_end
  tcp_protocol                              = local.tcp_protocol
  allow_subnet_traffic                      = local.allow_subnet_traffic
  ip_hsm_primary                            = local.ip_hsm_primary
  ip_hsm_secondary                          = local.ip_hsm_secondary
  ost_peering_id                            = var.pcx_preproduction_pki_ost_id
  ost_cidr_block                            = var.pcx_preproduction_pki_ost_cidr
  mojo_prod_tgw_id                          = var.mojo_prod_tgw_id
  gp_client_prod_cidr_block                 = var.gp_client_prod_cidr_block
  alz_cidr_block                            = var.alz_cidr_block

  prefix = var.prefix
  tags   = var.tags
}

module "pki_key_pair" {
  source = ".././key_pair"

  key_name_suffix = "pki-team-key-pair"

  prefix = var.prefix
  tags   = var.tags
}

module "vpn_pre-production" {
  source = ".././vpn"

  vpc_id = module.pki_vpc.vpc_id

  primary_remote_destination_cidr = var.primary_remote_destination_cidr
  primary_internal_cidr           = var.primary_internal_cidr

  backend_zone_route_table_id = module.pki_vpc.backend_zone_route_table_id

  secondary_remote_destination_cidr = var.secondary_remote_destination_cidr
  seondary_internal_cidr            = var.seondary_internal_cidr

  tertiary_remote_destination_cidr = var.tertiary_remote_destination_cidr
  tertiary_internal_cidr           = var.quarternary_internal_cidr

  quarternary_remote_destination_cidr = var.quarternary_remote_destination_cidr
  quarternary_internal_cidr            = var.quarternary_internal_cidr

  cgw_hsm_primary_id   = var.cgw_hsm_primary_id
  cgw_hsm_secondary_id = var.cgw_hsm_secondary_id
  cgw_hsm_tertiary_id   = var.cgw_hsm_tertiary_id
  cgw_hsm_quarternary_id = var.cgw_hsm_quarternary_id

  prefix = "pre-production"
}

module "tgw-attach" {
  source = ".././tgw"

  vpc_id                            = module.pki_vpc.vpc_id
  mojo_prod_tgw_id                  = var.mojo_prod_tgw_id
  private_subnet_private_ra_zone_id = module.pki_vpc.private_subnet_private_ra_zone_id

  prefix = var.prefix
}

