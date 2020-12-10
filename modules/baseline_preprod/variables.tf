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

variable "pcx_preproduction_pki_ost_id" {
  type = string
}

variable "pcx_preproduction_pki_ost_cidr" {
  type = string
}