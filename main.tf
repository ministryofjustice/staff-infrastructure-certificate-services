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
  region                     = data.aws_region.current_region.id
  cidr_block                 = "10.180.84.0/22"
  private_subnet_cidr_blocks = ["10.180.84.0/24", "10.180.85.0/24"]
  public_subnet_cidr_block   = "10.180.86.0/24"

  providers = {
    aws = aws.env
  }
}

module "ec2_test" {
  source = "./modules/ec2"

  prefix = module.label.id
  tags   = module.label.tags

  instance_count = 1
  ami            = "ami-016765c2bcb958f9b"
  instance_type  = "t2.micro"
  subnet_id      = module.test_vpc.public_subnet_ids[0]
  # subnet_id      = "subnet-0039c3b543ef64a07"
  key_name = "toby-test"


  providers = {
    aws = aws.env
  }
}
