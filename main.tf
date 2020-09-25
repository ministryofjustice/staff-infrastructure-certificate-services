terraform {
  required_version = "> 0.12.0"

  backend "s3" {
    bucket         = "pttp-ci-infrastructure-pki-client-core-tf-state"
    dynamodb_table = "pttp-ci-infrastructure-pki-client-core-tf-lock-table"
    region         = "eu-west-2"
  }
}

provider "aws" {
  version = "~> 2.68"
  alias   = "env"
  assume_role {
    role_arn = var.assume_role
  }
}

data "aws_region" "current_region" {}

module "label" {
  source  = "cloudposse/label/null"
  version = "0.16.0"

  #  TODO: change this to MoJ-Official?
  namespace = "pttp"
  stage     = terraform.workspace
  # TODO: change this?
  name      = "pki-infra"
  delimiter = "-"

  tags = {
    "business-unit" = "MoJO"
    "application"   = "certificate-services"
    "owner"         = var.owner_email

    # TODO: do we need this field?
    "environment-name" = "global"
    "source-code"      = "https://github.com/ministryofjustice/staff-infrastructure-certificate-services"
  }
}

module "s3_bucket_test" {
  source = "./modules/test"

  prefix = module.label.id
  tags   = module.label.tags

  providers = {
    aws = aws.env
  }
}


module "test_vpc" {
  source                     = "./modules/vpc"
  prefix                     = module.label.id
  tags                       = module.label.tags
  region                     = data.aws_region.current_region.id
  cidr_block                 = "10.180.84.0/22"
  private_subnet_cidr_blocks = ["10.180.84.0/24", "10.180.85.0/24"]
  public_subnet_cidr_block   = "10.180.86.0/24"

  providers = {
    aws = aws.env
  }
}

module "test_key_pair" {
  source          = "./modules/key_pair"
  prefix          = module.label.id
  key_name_suffix = "pki-team-key-pair"

  providers = {
    aws = aws.env
  }
}

module "test_ssh_sg" {
  name                = "toby-test-sg"
  source              = "./modules/sg"
  vpc_id              = module.test_vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  tags                = module.label.tags

  providers = {
    aws = aws.env
  }
}

module "public_certificate_authority_gateway" {
  source = "./modules/ec2"

  prefix = module.label.id
  tags   = module.label.tags

  instance_count = 1
  ami            = "ami-06fe0c124aedcef5f"
  instance_type  = "t2.micro"
  subnet_id      = module.test_vpc.public_subnets[0]
  key_name       = module.test_key_pair.key_name
  vpc_security_group_ids = [module.test_ssh_sg.this_security_group_id]


  providers = {
    aws = aws.env
  }
}

module "public_registration_authority_front_end" {
  source = "./modules/ec2"

  prefix = module.label.id
  tags   = module.label.tags

  instance_count = 1
  ami            = "ami-06fe0c124aedcef5f"
  instance_type  = "t2.micro"
  subnet_id      = module.test_vpc.public_subnets[0]
  key_name       = module.test_key_pair.key_name
  vpc_security_group_ids = [module.test_ssh_sg.this_security_group_id]


  providers = {
    aws = aws.env
  }
}

module "public_bastion_host_windows" {
  source = "./modules/ec2"

  prefix = module.label.id
  tags   = module.label.tags

  instance_count = 1
  ami            = "ami-0aac9d7fa83beb6d2"
  instance_type  = "t2.micro"
  subnet_id      = module.test_vpc.public_subnets[0]
  key_name       = module.test_key_pair.key_name
  vpc_security_group_ids = [module.test_ssh_sg.this_security_group_id]


  providers = {
    aws = aws.env
  }
}

module "private_issuing_certificate_authority" {
  source = "./modules/ec2"

  prefix = module.label.id
  tags   = module.label.tags

  instance_count = 1
  ami            = "ami-06fe0c124aedcef5f"
  instance_type  = "t2.micro"
  subnet_id      = module.test_vpc.private_subnets[0]
  key_name       = module.test_key_pair.key_name


  providers = {
    aws = aws.env
  }
}

module "private_registration_authority_back_end" {
  source = "./modules/ec2"

  prefix = module.label.id
  tags   = module.label.tags

  instance_count = 1
  ami            = "ami-06fe0c124aedcef5f"
  instance_type  = "t2.micro"
  subnet_id      = module.test_vpc.private_subnets[0]
  key_name       = module.test_key_pair.key_name


  providers = {
    aws = aws.env
  }
}

module "private_directory_server" {
  source = "./modules/ec2"

  prefix = module.label.id
  tags   = module.label.tags

  instance_count = 1
  ami            = "ami-06fe0c124aedcef5f"
  instance_type  = "t2.micro"
  subnet_id      = module.test_vpc.private_subnets[0]
  key_name       = module.test_key_pair.key_name


  providers = {
    aws = aws.env
  }
}
