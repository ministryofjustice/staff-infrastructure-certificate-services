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


# TODO: add a test VPC that uses the label module

module "test_vpc" {
  source     = "./modules/vpc"
  prefix     = module.label.id
  region     = data.aws_region.current_region.id
  cidr_block = var.logging_cidr_block

  providers = {
    aws = aws.env
  }
}
