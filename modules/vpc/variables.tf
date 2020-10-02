variable "cidr_block" {
  type = string
}

variable "region" {
  type = string
}

variable "prefix" {
  type = string
}

variable "public_subnet_cidr_block" {
  type = string
}

variable "private_subnet_backend_zone_cidr_block" {
  type = string
}

variable "private_subnet_private_ra_zone_cidr_block" {
  type = string
}

variable "tags" {
  type = map(string)
}
