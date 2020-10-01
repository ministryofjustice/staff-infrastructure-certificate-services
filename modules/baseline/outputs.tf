output "ec2_ca_gw_ip" {
  value = module.ec2_ca_gw.public_ip
}

output "private_key_pem_format" {
  value = module.test_key_pair.private_key_pem_format
}

output "ec2_bastion_public_ip" {
  value = module.ec2_bastion_host.public_ip
}

output "ec2_bastion_password_data" {
  value = module.ec2_bastion_host.password_data[0]
}
