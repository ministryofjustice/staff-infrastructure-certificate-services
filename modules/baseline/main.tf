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

  vpc_id              = module.test_vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]

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

  prefix = var.prefix
  tags   = var.tags
}

module "public_registration_authority_front_end" {
  source = ".././ec2"

  ami                    = local.rhel_7_6_x64
  instance_type          = "t2.micro"
  subnet_id              = module.test_vpc.public_subnets[0]
  key_name               = module.test_key_pair.key_name
  vpc_security_group_ids = [module.test_ssh_sg.this_security_group_id]

  prefix = var.prefix
  tags   = var.tags
}

module "public_bastion_host_windows" {
  source = ".././ec2"

  ami                    = local.windows_2019_x64
  instance_type          = "t2.micro"
  subnet_id              = module.test_vpc.public_subnets[0]
  key_name               = module.test_key_pair.key_name
  vpc_security_group_ids = [module.test_ssh_sg.this_security_group_id]

  prefix = var.prefix
  tags   = var.tags
}

module "private_issuing_certificate_authority" {
  source = ".././ec2"

  ami           = local.rhel_7_6_x64
  instance_type = "t2.micro"
  subnet_id     = module.test_vpc.private_subnets[0]
  key_name      = module.test_key_pair.key_name

  prefix = var.prefix
  tags   = var.tags
}

module "private_registration_authority_back_end" {
  source = ".././ec2"

  ami           = local.rhel_7_6_x64
  instance_type = "t2.micro"
  subnet_id     = module.test_vpc.private_subnets[0]
  key_name      = module.test_key_pair.key_name

  prefix = var.prefix
  tags   = var.tags
}

module "private_directory_server" {
  source = ".././ec2"

  ami           = local.rhel_7_6_x64
  instance_type = "t2.micro"
  subnet_id     = module.test_vpc.private_subnets[0]
  key_name      = module.test_key_pair.key_name

  prefix = var.prefix
  tags   = var.tags
}
