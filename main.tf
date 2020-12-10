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

  name      = "pki"
  delimiter = "-"

  tags = {
    "business-unit" = "MoJO"
    "application"   = "certificate-services"

    "environment-name" = "global"
    "source-code"      = "https://github.com/ministryofjustice/staff-infrastructure-certificate-services"
  }
}

module "baseline_pre_production" {
  source = "./modules/baseline_preprod"

  prefix                  = "pre-production-${module.label.id}"
  tags                    = module.label.tags
  environment_description = "pre-production"

  region_id = data.aws_region.current_region.id

  trusted_cidr = var.trusted_cidr

  pcx_preproduction_pki_ost_id   = var.pcx_preproduction_pki_ost_id
  pcx_preproduction_pki_ost_cidr = var.pcx_preproduction_pki_ost_cidr

  providers = {
    aws = aws.env
  }
}

module "baseline_production" {
  source = "./modules/baseline"

  prefix                  = "production-${module.label.id}"
  tags                    = module.label.tags
  environment_description = "production"

  region_id = data.aws_region.current_region.id

  trusted_cidr = var.trusted_cidr

  pcx_production_pki_ost_id   = var.pcx_production_pki_ost_id
  pcx_production_pki_ost_cidr = var.pcx_production_pki_ost_cidr

  customer_gateway_primary_ip     = var.customer_gateway_primary_ip
  primary_remote_destination_cidr = var.primary_remote_destination_cidr
  primary_internal_cidr           = var.primary_internal_cidr

  customer_gateway_secondary_ip     = var.customer_gateway_secondary_ip
  secondary_remote_destination_cidr = var.secondary_remote_destination_cidr
  seondary_internal_cidr            = var.seondary_internal_cidr

  providers = {
    aws = aws.env
  }
}


