terraform {
  required_version = "> 0.12.0"
  backend "s3" {
    bucket         = "moj-pttp-pki-aws-infrastructure-terraform-state"
    key            = "global/s3/terraform.tfstate"
    dynamodb_table = "moj-pttp-pki-aws-infrastructure-terraform-state-locks"
    encrypt        = true
  }
}

provider "aws" {
  version = "~> 2.68"
  alias   = "env"
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

    # TODO: do we need this field?
    "environment-name" = "global"
    "source-code"      = "https://github.com/ministryofjustice/staff-infrastructure-certificate-services"
  }
}

module "baseline_test_pre_production" {
  source = "./modules/baseline"

  prefix = "${module.label.id}-pre-production"
  tags   = module.label.tags

  region_id = data.aws_region.current_region.id

  providers = {
    aws = aws.env
  }
}

module "baseline_test_production" {
  source = "./modules/baseline"

  prefix = "${module.label.id}-production"
  tags   = module.label.tags

  region_id = data.aws_region.current_region.id

  providers = {
    aws = aws.env
  }
}
