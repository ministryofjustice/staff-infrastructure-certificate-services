locals {
  rhel_7_6_x64     = "ami-06fe0c124aedcef5f"
  windows_2019_x64 = "ami-0aac9d7fa83beb6d2"
}

module "s3_bucket_test" {
  source = ".././s3"

  prefix = var.prefix
  tags   = var.tags
}

module "test_vpc" {
  source = ".././vpc"

  region                     = var.region_id
  cidr_block                 = "10.180.84.0/22"
  private_subnet_cidr_blocks = ["10.180.84.0/24", "10.180.85.0/24"]
  public_subnet_cidr_block   = "10.180.86.0/24"

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

  prefix = var.prefix
  tags   = var.tags
}

module "public_certificate_authority_gateway_sg" {
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

  prefix = var.prefix
  tags   = var.tags
}

module "public_registration_authority_front_end_sg" {
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

  prefix = var.prefix
  tags   = var.tags
}

module "public_bastion_host_windows_sg" {
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

  prefix = var.prefix
  tags   = var.tags
}

module "private_issuing_certificate_authority_sg" {
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
      to_port     = 709
      protocol    = "tcp"
      description = ""
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 710
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

module "private_registration_authority_back_end_sg" {
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

  prefix = var.prefix
  tags   = var.tags
}

module "private_directory_server_sg" {
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

  prefix = var.prefix
  tags   = var.tags
}

module "public_certificate_authority_gateway" {
  source = ".././ec2"

  ami                    = local.rhel_7_6_x64
  instance_type          = "t2.micro"
  subnet_id              = module.test_vpc.public_subnets[0]
  key_name               = module.test_key_pair.key_name
  vpc_security_group_ids = [module.test_ssh_sg.this_security_group_id]

  name = "${var.prefix}-ca-gateway"
  tags = var.tags
}

module "public_registration_authority_front_end" {
  source = ".././ec2"

  ami           = local.rhel_7_6_x64
  instance_type = "t2.micro"
  subnet_id     = module.test_vpc.public_subnets[0]
  key_name      = module.test_key_pair.key_name

  name = "${var.prefix}-ra-front-end"
  tags = var.tags
}

module "public_bastion_host_windows" {
  source = ".././ec2"

  ami           = local.windows_2019_x64
  instance_type = "t2.micro"
  subnet_id     = module.test_vpc.public_subnets[0]
  key_name      = module.test_key_pair.key_name

  name = "${var.prefix}-bastion-host"
  tags = var.tags
}

module "private_issuing_certificate_authority" {
  source = ".././ec2"

  ami           = local.rhel_7_6_x64
  instance_type = "t2.micro"
  subnet_id     = module.test_vpc.private_subnets[0]
  key_name      = module.test_key_pair.key_name

  name = "${var.prefix}-issuing-ca"
  tags = var.tags
}

module "private_registration_authority_back_end" {
  source = ".././ec2"

  ami           = local.rhel_7_6_x64
  instance_type = "t2.micro"
  subnet_id     = module.test_vpc.private_subnets[0]
  key_name      = module.test_key_pair.key_name

  name = "${var.prefix}-ra-back-end"
  tags = var.tags
}

module "private_directory_server" {
  source = ".././ec2"

  ami           = local.rhel_7_6_x64
  instance_type = "t2.micro"
  subnet_id     = module.test_vpc.private_subnets[0]
  key_name      = module.test_key_pair.key_name

  name = "${var.prefix}-directory-server"
  tags = var.tags
}
