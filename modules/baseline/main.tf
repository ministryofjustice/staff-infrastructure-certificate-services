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

module "sg_ra_back_end" {
  source = ".././sg"

  vpc_id = module.pki_vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 9009
      to_port     = 9009
      protocol    = "tcp"
      description = ""
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 9039
      to_port     = 9039
      protocol    = "tcp"
      description = ""
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8010
      to_port     = 8013
      protocol    = "tcp"
      description = ""
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = ""
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  egress_with_cidr_blocks = []

  prefix = var.prefix
  tags   = var.tags
}

module "sg_directory" {
  source = ".././sg"

  vpc_id = module.pki_vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 389
      to_port     = 389
      protocol    = "tcp"
      description = ""
      cidr_blocks = "0.0.0.0/0" // TODO: We should limit this to CA GW and Issuing CA only
    },
  ]
  egress_with_cidr_blocks = []

  prefix = var.prefix
  tags   = var.tags
}

module "ec2_ra_back_end" {
  source = ".././ec2"

  ami           = local.ami_rhel_7_6_x64
  instance_type = "t2.micro"
  subnet_id     = module.pki_vpc.private_subnets[1]
  # private_ip             = local.ip_ra_back_end
  key_name               = module.test_key_pair.key_name
  vpc_security_group_ids = [module.sg_ra_back_end.this_security_group_id]

  name = "${var.prefix}-ra-back-end"
  tags = var.tags
}

module "ec2_directory" {
  source = ".././ec2"

  ami           = local.ami_rhel_7_6_x64
  instance_type = "t2.micro"
  subnet_id     = module.pki_vpc.private_subnets[1]
  # private_ip             = local.ip_directory
  key_name               = module.test_key_pair.key_name
  vpc_security_group_ids = [module.sg_directory.this_security_group_id]

  name = "${var.prefix}-directory"
  tags = var.tags
}
