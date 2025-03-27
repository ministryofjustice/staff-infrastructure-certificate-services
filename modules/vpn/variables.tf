variable "vpc_id" {
  type = string
}

variable "prefix" {
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

variable "backend_zone_route_table_id" {
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
