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

module "label" {
  source  = "cloudposse/label/null"
  version = "0.16.0"

  #  TODO: change this to MoJ-Official?
  namespace = "pttp"
  stage     = terraform.workspace
  # TODO: change this?
  name      = "infra"
  delimiter = "-"

  # TODO: update these?
  tags = {
    "business-unit" = "MoJO"
    "application"   = "infrastructure"
    "owner" = var.owner_email

    # TODO: do we need this?
    "environment-name" = "global"
    # TODO: do we need this?
    "source-code" = "https://github.com/ministryofjustice/pttp-infrastructure"
  }
}

module "prometheus" {
  source = "./modules/test"

  prefix = module.label.id
  # tags                       = module.label.tags

  providers = {
    aws = aws.env
  }
}


# TODO: add a test VPC that uses the label module
