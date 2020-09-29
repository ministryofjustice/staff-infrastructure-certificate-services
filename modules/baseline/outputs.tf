output "ec2_ca_gw_ip" {
  value = module.ec2_ca_gw.private_ip
}

output "private_key_pem_format" {
  value = module.test_key_pair.private_key_pem_format
}
