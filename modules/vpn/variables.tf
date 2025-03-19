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

variable "tertiary_remote_destination_cidr" {
  type = string
}

variable "tertiary_internal_cidr" {
  type = string
}

variable "quarternary_remote_destination_cidr" {
  type = string
}

variable "quarternary_internal_cidr" {
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

variable "cgw_hsm_tertiary_id" {
  type = string
}

variable "cgw_hsm_quarternary_id" {
  type = string
}
