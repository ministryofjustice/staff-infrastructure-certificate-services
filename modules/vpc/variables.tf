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

variable "public_internet_cidr_block" {
  type = string
}

variable "ssh_port" {
  type = number
}

variable "rdp_port" {
  type = number
}

variable "tcp_port_range_start" {
  type = number
}

variable "tcp_port_range_end" {
  type = number
}

variable "http_port" {
  type = number
}

variable "https_port" {
  type = number
}

variable "ephemeral_port_start" {
  type = number
}

variable "ephemeral_port_end" {
  type = number
}

variable "tcp_protocol" {
  type = string
}

variable "allow_subnet_traffic" {
  type = string
}

variable "ip_hsm_primary" {
  type = string
}

variable "ip_hsm_secondary" {
  type = string
}

variable "ost_cidr_block" {
  type = string
}

variable "ost_peering_id" {
  type = string
}

variable "mojo_tgw_id" {
    type = string
}

variable "tags" {
  type = map(string)
}
