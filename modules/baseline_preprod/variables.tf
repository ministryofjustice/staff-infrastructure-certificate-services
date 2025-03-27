variable "prefix" {
  type = string
}

variable "tags" {
  type = map(string)
}

variable "region_id" {
  type = string
}

variable "environment_description" {
  type = string
}

variable "trusted_cidr" {
  type = string
}

variable "primary_remote_destination_cidr" {
  type = string
}

variable "primary_internal_cidr" {
  type = string
}

variable "secondary_remote_destination_cidr" {
  type = string
}

variable "seondary_internal_cidr" {
  type = string
}

variable "ld6_remote_destination_cidr" {
  type = string
}

variable "ld6_internal_cidr" {
  type = string
}

variable "tsc_remote_destination_cidr" {
  type = string
}

variable "tsc_internal_cidr" {
  type = string
}

variable "cgw_hsm_primary_id" {
  type = string
}

variable "cgw_hsm_secondary_id" {
  type = string
}

variable "cgw_hsm_ld6_id" {
  type = string
}

variable "cgw_hsm_tsc_id" {
  type = string
}

variable "pcx_preproduction_pki_ost_id" {
  type = string
}

variable "pcx_preproduction_pki_ost_cidr" {
  type = string
}

variable "mojo_prod_tgw_id" {
  type = string
}

variable "gp_client_prod_cidr_block" {
  type = string
}

variable "alz_cidr_block" {
  type = string
}

variable "ms_teams_webhook_url" {
  type = string
}

variable "sns_topic_arn" {
  type = string
}
