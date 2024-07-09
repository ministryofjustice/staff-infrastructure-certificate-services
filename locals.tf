locals {
  pcx_production_pki_ost_cidr       = data.aws_secretsmanager_secret_version.pcx_production_pki_ost_cidr.secret_string
  trusted_cidr                      = data.aws_secretsmanager_secret_version.trusted_cidr.secret_string
  mojo_prod_tgw_id                  = data.aws_secretsmanager_secret_version.mojo_prod_tgw_id.secret_string
  secondary_internal_cidr           = data.aws_secretsmanager_secret_version.secondary_internal_cidr.secret_string
  pcx_preproduction_pki_ost_cidr    = data.aws_secretsmanager_secret_version.pcx_preproduction_pki_ost_cidr.secret_string
  pcx_preproduction_pki_ost_id      = data.aws_secretsmanager_secret_version.pcx_preproduction_pki_ost_id.secret_string
  primary_remote_destination_cidr   = data.aws_secretsmanager_secret_version.primary_remote_destination_cidr.secret_string
  alz_cidr_block                    = data.aws_secretsmanager_secret_version.alz_cidr_block.secret_string
  pcx_production_pki_ost_id         = data.aws_secretsmanager_secret_version.pcx_production_pki_ost_id.secret_string
  secondary_remote_destination_cidr = data.aws_secretsmanager_secret_version.secondary_remote_destination_cidr.secret_string
  primary_internal_cidr             = data.aws_secretsmanager_secret_version.primary_internal_cidr.secret_string
  gp_client_prod_cidr_block         = data.aws_secretsmanager_secret_version.gp_client_prod_cidr_block.secret_string
  mojo_production_account_id        = data.aws_secretsmanager_secret_version.mojo_production_account_id.secret_string
  assume_role                       = data.aws_secretsmanager_secret_version.assume_role_arn.secret_string
  cgw_hsm_primary_ip                = data.aws_secretsmanager_secret_version.cgw_hsm_primary_ip.secret_string
  cgw_hsm_secondary_ip              = data.aws_secretsmanager_secret_version.cgw_hsm_secondary_ip.secret_string
}
