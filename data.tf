data "aws_secretsmanager_secret" "pcx_production_pki_ost_cidr" {
  name = "staff-infrastructure-certificate-services/production/pcx_production_pki_ost_cidr"
}
data "aws_secretsmanager_secret_version" "pcx_production_pki_ost_cidr" {
  secret_id = data.aws_secretsmanager_secret.pcx_production_pki_ost_cidr.id
}

data "aws_secretsmanager_secret" "trusted_cidr" {
  name = "staff-infrastructure-certificate-services/production/trusted_cidr"
}
data "aws_secretsmanager_secret_version" "trusted_cidr" {
  secret_id = data.aws_secretsmanager_secret.trusted_cidr.id
}

data "aws_secretsmanager_secret" "mojo_prod_tgw_id" {
  name = "staff-infrastructure-certificate-services/production/mojo_prod_tgw_id"
}
data "aws_secretsmanager_secret_version" "mojo_prod_tgw_id" {
  secret_id = data.aws_secretsmanager_secret.mojo_prod_tgw_id.id
}

data "aws_secretsmanager_secret" "secondary_internal_cidr" {
  name = "staff-infrastructure-certificate-services/production/secondary_internal_cidr"
}
data "aws_secretsmanager_secret_version" "secondary_internal_cidr" {
  secret_id = data.aws_secretsmanager_secret.secondary_internal_cidr.id
}

data "aws_secretsmanager_secret" "pcx_preproduction_pki_ost_cidr" {
  name = "staff-infrastructure-certificate-services/production/pcx_preproduction_pki_ost_cidr"
}
data "aws_secretsmanager_secret_version" "pcx_preproduction_pki_ost_cidr" {
  secret_id = data.aws_secretsmanager_secret.pcx_preproduction_pki_ost_cidr.id
}

data "aws_secretsmanager_secret" "pcx_preproduction_pki_ost_id" {
  name = "staff-infrastructure-certificate-services/production/pcx_preproduction_pki_ost_id"
}
data "aws_secretsmanager_secret_version" "pcx_preproduction_pki_ost_id" {
  secret_id = data.aws_secretsmanager_secret.pcx_preproduction_pki_ost_id.id
}

data "aws_secretsmanager_secret" "primary_remote_destination_cidr" {
  name = "staff-infrastructure-certificate-services/production/primary_remote_destination_cidr"
}
data "aws_secretsmanager_secret_version" "primary_remote_destination_cidr" {
  secret_id = data.aws_secretsmanager_secret.primary_remote_destination_cidr.id
}

data "aws_secretsmanager_secret" "alz_cidr_block" {
  name = "staff-infrastructure-certificate-services/production/alz_cidr_block"
}
data "aws_secretsmanager_secret_version" "alz_cidr_block" {
  secret_id = data.aws_secretsmanager_secret.alz_cidr_block.id
}

data "aws_secretsmanager_secret" "pcx_production_pki_ost_id" {
  name = "staff-infrastructure-certificate-services/production/pcx_production_pki_ost_id"
}
data "aws_secretsmanager_secret_version" "pcx_production_pki_ost_id" {
  secret_id = data.aws_secretsmanager_secret.pcx_production_pki_ost_id.id
}

data "aws_secretsmanager_secret" "secondary_remote_destination_cidr" {
  name = "staff-infrastructure-certificate-services/production/secondary_remote_destination_cidr"
}
data "aws_secretsmanager_secret_version" "secondary_remote_destination_cidr" {
  secret_id = data.aws_secretsmanager_secret.secondary_remote_destination_cidr.id
}

data "aws_secretsmanager_secret" "primary_internal_cidr" {
  name = "staff-infrastructure-certificate-services/production/primary_internal_cidr"
}
data "aws_secretsmanager_secret_version" "primary_internal_cidr" {
  secret_id = data.aws_secretsmanager_secret.primary_internal_cidr.id
}

data "aws_secretsmanager_secret" "gp_client_prod_cidr_block" {
  name = "staff-infrastructure-certificate-services/production/gp_client_prod_cidr_block"
}
data "aws_secretsmanager_secret_version" "gp_client_prod_cidr_block" {
  secret_id = data.aws_secretsmanager_secret.gp_client_prod_cidr_block.id
}

data "aws_secretsmanager_secret" "mojo_production_account_id" {
  name = "staff-infrastructure-certificate-services/production/mojo_production_account_id"
}
data "aws_secretsmanager_secret_version" "mojo_production_account_id" {
  secret_id = data.aws_secretsmanager_secret.mojo_production_account_id.id
}

data "aws_secretsmanager_secret" "assume_role_arn" {
  name = "staff-infrastructure-certificate-services/production/assume_role_arn"
}
data "aws_secretsmanager_secret_version" "assume_role_arn" {
  secret_id = data.aws_secretsmanager_secret.assume_role_arn.id
}

data "aws_secretsmanager_secret" "cgw_hsm_primary_ip" {
  name = "staff-infrastructure-certificate-services/production/cgw_hsm_primary_ip"
}
data "aws_secretsmanager_secret_version" "cgw_hsm_primary_ip" {
  secret_id = data.aws_secretsmanager_secret.cgw_hsm_primary_ip.id
}

data "aws_secretsmanager_secret" "cgw_hsm_secondary_ip" {
  name = "staff-infrastructure-certificate-services/production/cgw_hsm_secondary_ip"
}
data "aws_secretsmanager_secret_version" "cgw_hsm_secondary_ip" {
  secret_id = data.aws_secretsmanager_secret.cgw_hsm_secondary_ip.id
}
