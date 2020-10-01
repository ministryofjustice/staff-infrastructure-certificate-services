output "ca_gateway_public_ip" {
  value = module.ec2_ca_gateway.public_ip
}

output "private_key_pem_format" {
  value = module.pki_key_pair.private_key_pem_format
}

output "ec2_bastion_public_ip" {
  value = module.ec2_bastion_host.public_ip
}

output "ec2_bastion_password_data" {
  value = module.ec2_bastion_host.password_data[0]
}
