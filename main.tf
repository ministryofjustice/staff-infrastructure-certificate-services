terraform {
  backend "s3" {
    bucket = "mojo-pki-aws-infrastructure-terraform-state"
    # key            = "global/s3/terraform.tfstate"
    dynamodb_table = "mojo-pki-aws-infrastructure-terraform-state-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = var.region
  alias  = "env"

  assume_role {
    role_arn = local.assume_role
  }
}

data "aws_region" "current_region" {}

module "label" {
  source  = "cloudposse/label/null"
  version = "0.25.0"

  name      = "pki"
  delimiter = "-"

  tags = {
    "business-unit" = "MoJO"
    "application"   = "certificate-services"

    "environment-name" = "global"
    "source-code"      = "https://github.com/ministryofjustice/staff-infrastructure-certificate-services"
  }
}

module "cgw" {
  source = "./modules/cgw"

  cgw_hsm_primary_ip   = local.cgw_hsm_primary_ip
  cgw_hsm_secondary_ip = local.cgw_hsm_secondary_ip

  providers = {
    aws = aws.env
  }
}

module "iam" {
  source = "./modules/iam"

  mojo_production_account_id = local.mojo_production_account_id

  providers = {
    aws = aws.env
  }
}

module "baseline_pre_production" {
  source = "./modules/baseline_preprod"

  prefix                  = "pre-production-${module.label.id}"
  tags                    = module.label.tags
  environment_description = "pre-production"

  region_id = data.aws_region.current_region.id

  trusted_cidr = local.trusted_cidr

  primary_remote_destination_cidr = local.primary_remote_destination_cidr
  primary_internal_cidr           = local.primary_internal_cidr

  secondary_remote_destination_cidr = local.secondary_remote_destination_cidr
  seondary_internal_cidr            = local.secondary_internal_cidr

  cgw_hsm_primary_id   = module.cgw.cgw_hsm_primary_id
  cgw_hsm_secondary_id = module.cgw.cgw_hsm_secondary_id

  pcx_preproduction_pki_ost_id   = local.pcx_preproduction_pki_ost_id
  pcx_preproduction_pki_ost_cidr = local.pcx_preproduction_pki_ost_cidr

  mojo_prod_tgw_id          = local.mojo_prod_tgw_id
  gp_client_prod_cidr_block = local.gp_client_prod_cidr_block
  alz_cidr_block            = local.alz_cidr_block

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

  trusted_cidr = local.trusted_cidr

  primary_remote_destination_cidr = local.primary_remote_destination_cidr
  primary_internal_cidr           = local.primary_internal_cidr

  secondary_remote_destination_cidr = local.secondary_remote_destination_cidr
  seondary_internal_cidr            = local.secondary_internal_cidr

  cgw_hsm_primary_id   = module.cgw.cgw_hsm_primary_id
  cgw_hsm_secondary_id = module.cgw.cgw_hsm_secondary_id

  pcx_production_pki_ost_id   = local.pcx_production_pki_ost_id
  pcx_production_pki_ost_cidr = local.pcx_production_pki_ost_cidr

  mojo_prod_tgw_id          = local.mojo_prod_tgw_id
  gp_client_prod_cidr_block = local.gp_client_prod_cidr_block
  alz_cidr_block            = local.alz_cidr_block

  providers = {
    aws = aws.env
  }
}

module "lambda_stop_start" {
  source = "./modules/lambda_stop_start"

  providers = {
    aws = aws.env
  }
}
