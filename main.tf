terraform {
  required_version = "> 0.12.0"

  backend "s3" {
    # TODO:  Where does this bucket name come from?Is it defined in the Pipeline setup script
    # bucket         = "pttp-ci-infrastructure-client-core-tf-state"
    # TODO: do we need to create this table manually in SS?
    # dynamodb_table = "pttp-ci-infrastructure-client-core-tf-lock-table"
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
}

# TODO: do we need this?
provider "tls" {
  version = "> 2.1"
}

# TODO: do we need this?
provider "local" {
  version = "~> 1.4"
}

# TODO: do we need this?
provider "template" {
  version = "~> 2.1"
}

# TODO: do we need this?
provider "random" {
  version = "~> 2.2.1"
}

# TODO: do we need this?
data "aws_region" "current_region" {}

# TODO: do we need this?
data "aws_caller_identity" "shared_services_account" {}

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
    # TODO: do we need this?
    # "is-production" = tostring(var.is-production)
    "owner"         = var.owner_email

    # TODO: do we need this?
    "environment-name" = "global"
    # TODO: do we need this?
    "source-code"      = "https://github.com/ministryofjustice/pttp-infrastructure"
  }
}

# TODO: add a test VPC that uses the label module