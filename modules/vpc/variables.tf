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

variable "tcp_protocol" {
  type = string
}

variable "tags" {
  type = map(string)
}
