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
  tcp_protocol                              = local.tcp_protocol

  prefix = var.prefix
  tags   = var.tags
}

module "pki_key_pair" {
  source = ".././key_pair"

  key_name_suffix = "pki-team-key-pair"

  prefix = var.prefix
  tags   = var.tags
}
