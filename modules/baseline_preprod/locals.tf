locals {
  # General
  ami_rhel_7_6_x64           = "ami-06fe0c124aedcef5f"
  ami_windows_2019_x64       = "ami-0aac9d7fa83beb6d2"
  instance_type_linux        = "t2.medium"
  instance_type_windows      = "t2.medium"
  public_internet_cidr_block = "0.0.0.0/0"
  ssh_port                   = 22
  rdp_port                   = 3389
  tcp_port_range_start       = 0
  tcp_port_range_end         = 65535
  ldap_port                  = 389
  http_port                  = 80
  https_port                 = 443
  ephemeral_port_start       = 1024
  ephemeral_port_end         = 65535
  tcp_protocol               = "tcp"
  allow_subnet_traffic       = "allow"
  hsm_port                   = 1792

  # MoJ
  trusted_cidr_local = "51.149.250.0/24"

  # VPC
  cidr_block_vpc = "10.180.84.0/22"

  # Public subnet
  cidr_public_subnet = "10.180.86.0/24"

  ip_bastion_host  = "10.180.86.4"
  ip_reverse_proxy = "10.180.86.5"

  cidr_bastion_host  = "10.180.86.4/32"
  cidr_reverse_proxy = "10.180.86.5/32"

  # Backend zone
  cidr_private_backend_zone = "10.180.85.0/24"

  ip_issuing_ca    = "10.180.85.4"
  ip_ldap          = "10.180.85.5"
  ip_ra_app_server = "10.180.85.6"
  ip_ca_gateway    = "10.180.85.7"

  cidr_issuing_ca    = "10.180.85.4/32"
  cidr_ldap          = "10.180.85.5/32"
  cidr_ra_app_server = "10.180.85.6/32"
  cidr_ca_gateway    = "10.180.85.7/32"

  # RA zone
  cidr_private_ra_zone = "10.180.84.0/24"

  ip_ra_web_server = "10.180.84.4"

  cidr_ra_web_server = "10.180.84.4/32"

  # HSM Servers
  ip_hsm_primary   = "192.168.130.24/32"
  ip_hsm_secondary = "192.168.30.24/32"
  ip_hsm_ld6       = "192.168.31.2/32"
  ip_hsm_tsc       = "192.168.41.2/32"

  # RFC1918 Private Networks
  cidr_private_a = "10.0.0.0/8"
  cidr_private_b = "172.16.0.0/12"
  cidr_private_c = "192.168.0.0/16"

  sns_topic_alarm_action = "arn:aws:sns:${var.region_id}:${data.aws_caller_identity.current.account_id}:ec2-alarm-sns"

}
