locals {
  ami_rhel_7_6_x64     = "ami-06fe0c124aedcef5f"
  ami_windows_2019_x64 = "ami-0aac9d7fa83beb6d2"

  cidr_usage_route_table = "10.180.84.0/22"
  cidr_private_a         = "10.180.84.0/24"
  cidr_private_b         = "10.180.85.0/24"
  cidr_public_a          = "10.180.86.0/24"

  ip_bastion_host = ""

  ip_ca_gw        = ""
  ip_ra_front_end = ""

  ip_issuing_ca  = ""
  ip_ra_back_end = ""
  ip_directory   = ""
}

module "pki_vpc" {
  source = ".././vpc"

  region                     = var.region_id
  cidr_block                 = local.cidr_usage_route_table
  private_subnet_cidr_blocks = [local.cidr_private_a, local.cidr_private_b]
  public_subnet_cidr_block   = local.cidr_public_a

  prefix = var.prefix
  tags   = var.tags
}

module "test_key_pair" {
  source = ".././key_pair"

  key_name_suffix = "pki-team-key-pair"

  prefix = var.prefix
  tags   = var.tags
}
