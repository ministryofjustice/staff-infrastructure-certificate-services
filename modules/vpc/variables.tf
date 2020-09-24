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

variable "private_subnet_cidr_blocks" {
  type = list(string)
}

variable "tags" {
  type = map(string)
}
