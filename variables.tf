variable "env" {
  type    = string
  default = "development"
}

variable "region" {
  type = string
  default = "eu-west-2"
}

variable "assume_role" {
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

variable "cgw_hsm_primary_ip" {
  type = string
}

variable "cgw_hsm_secondary_ip" {
  type = string
}

variable "pcx_preproduction_pki_ost_id" {
  type = string
}

variable "pcx_production_pki_ost_id" {
  type = string
}

variable "pcx_preproduction_pki_ost_cidr" {
  type = string
}

variable "pcx_production_pki_ost_cidr" {
  type = string
}

variable "mojo_prod_tgw_id" {
  type = string
}

variable "gp_client_prod_cidr_block" {
  type = string
}

variable "mojo_production_account_id" {
  type = string
}