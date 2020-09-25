output "public_key" {
  value = module.test_key_pair.public_key
}

output "public_key_pem_format" {
  value = module.test_key_pair.public_key_pem_format
}

output "private_key_pem_format" {
  value = module.test_key_pair.private_key_pem_format
}

output "public_ip" {
  value = module.ec2_alpine_public.public_ip
}
