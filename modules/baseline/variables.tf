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

variable "cgw_hsm_primary_id" {
  type = string
}

variable "cgw_hsm_secondary_id" {
  type = string
}

variable "pcx_production_pki_ost_id" {
  type = string
}

variable "pcx_production_pki_ost_cidr" {
  type = string
}

variable "mojo_prod_tgw_id" {
  type = string
}

variable "gp_client_cidr_block" {
  type = string
} 