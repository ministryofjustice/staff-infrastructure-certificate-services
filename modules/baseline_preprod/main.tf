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

  prefix = var.prefix
  tags   = var.tags
}

module "pki_key_pair" {
  source = ".././key_pair"

  key_name_suffix = "pki-team-key-pair"

  prefix = var.prefix
  tags   = var.tags
}
