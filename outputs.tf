output "public_key" {
  value = module.test_key_pair.public_key
}

output "public_key_pem_format" {
  value = module.test_key_pair.public_key_pem_format
}

output "public_ip" {
  value = module.ec2_alpine_public.public_ip
}
