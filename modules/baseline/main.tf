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

module "s3_bucket_test" {
  source = ".././s3"

  prefix = var.prefix
  tags   = var.tags
}

module "test_vpc" {
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

module "test_ssh_sg" {
  source = ".././sg"

  vpc_id = module.test_vpc.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "ssh"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  egress_with_cidr_blocks = []

  prefix = var.prefix
  tags   = var.tags
}

module "sg_bastion_host" {
  source = ".././sg"

  vpc_id = module.test_vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 3389
      to_port     = 3389
      protocol    = "tcp"
      description = ""
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  egress_with_cidr_blocks = []

  prefix = var.prefix
  tags   = var.tags
}

module "sg_ca_gw" {
  source = ".././sg"

  vpc_id = module.test_vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8080
      protocol    = "tcp"
      description = "http"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "https"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 1443
      to_port     = 1443
      protocol    = "tcp"
      description = ""
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 709
      to_port     = 710
      protocol    = "tcp"
      description = ""
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 829
      to_port     = 829
      protocol    = "tcp"
      description = ""
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  prefix = var.prefix
  tags   = var.tags
}

module "sg_ra_front_end" {
  source = ".././sg"

  vpc_id = module.test_vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "https"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 20443
      to_port     = 20443
      protocol    = "tcp"
      description = ""
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 21443
      to_port     = 21443
      protocol    = "tcp"
      description = ""
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 22443
      to_port     = 22443
      protocol    = "tcp"
      description = ""
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 8030
      to_port     = 8030
      protocol    = "tcp"
      description = ""
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  egress_with_cidr_blocks = [
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

  prefix = var.prefix
  tags   = var.tags
}

module "sg_issuing_ca" {
  source = ".././sg"

  vpc_id = module.test_vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "https"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 1443
      to_port     = 1443
      protocol    = "tcp"
      description = ""
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 709
      to_port     = 710
      protocol    = "tcp"
      description = ""
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 829
      to_port     = 829
      protocol    = "tcp"
      description = ""
      cidr_blocks = "0.0.0.0/0"
    },
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 389
      to_port     = 389
      protocol    = "tcp"
      description = ""
      cidr_blocks = "0.0.0.0/0"
    },
  ]

  prefix = var.prefix
  tags   = var.tags
}

module "sg_ra_back_end" {
  source = ".././sg"

  vpc_id = module.test_vpc.vpc_id

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

  vpc_id = module.test_vpc.vpc_id

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

module "ec2_bastion_host" {
  source = ".././ec2"

  ami           = local.ami_windows_2019_x64
  instance_type = "t2.micro"
  subnet_id     = module.test_vpc.private_subnets[0]
  # private_ip             = local.ip_bastion_host
  key_name               = module.test_key_pair.key_name
  vpc_security_group_ids = [module.sg_bastion_host.this_security_group_id]

  name = "${var.prefix}-bastion-host"
  tags = var.tags
}

module "ec2_ca_gw" {
  source = ".././ec2"

  ami           = local.ami_rhel_7_6_x64
  instance_type = "t2.micro"
  subnet_id     = module.test_vpc.private_subnets[0]
  # public_ip              = local.ip_ca_gw
  key_name               = module.test_key_pair.key_name
  vpc_security_group_ids = [module.sg_ca_gw.this_security_group_id]

  name = "${var.prefix}-ca-gw"
  tags = var.tags
}

module "ec2_ra_front_end" {
  source = ".././ec2"

  ami           = local.ami_rhel_7_6_x64
  instance_type = "t2.micro"
  subnet_id     = module.test_vpc.private_subnets[0]
  # private_ip             = local.ip_ra_front_end
  key_name               = module.test_key_pair.key_name
  vpc_security_group_ids = [module.sg_ra_front_end.this_security_group_id]

  name = "${var.prefix}-ra-front-end"
  tags = var.tags
}

module "ec2_issuing_ca" {
  source = ".././ec2"

  ami           = local.ami_rhel_7_6_x64
  instance_type = "t2.micro"
  subnet_id     = module.test_vpc.private_subnets[1]
  # private_ip             = local.ip_issuing_ca
  key_name               = module.test_key_pair.key_name
  vpc_security_group_ids = [module.sg_issuing_ca.this_security_group_id]

  name = "${var.prefix}-issuing-ca"
  tags = var.tags
}

module "ec2_ra_back_end" {
  source = ".././ec2"

  ami           = local.ami_rhel_7_6_x64
  instance_type = "t2.micro"
  subnet_id     = module.test_vpc.private_subnets[1]
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
  subnet_id     = module.test_vpc.private_subnets[1]
  # private_ip             = local.ip_directory
  key_name               = module.test_key_pair.key_name
  vpc_security_group_ids = [module.sg_directory.this_security_group_id]

  name = "${var.prefix}-directory"
  tags = var.tags
}
