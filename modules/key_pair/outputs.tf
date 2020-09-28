output "public_key" {
  value = tls_private_key.this.public_key_openssh
}

output "public_key_pem_format" {
  value = tls_private_key.this.public_key_pem
}

output "private_key_pem_format" {
  value = tls_private_key.this.private_key_pem
}

output "key_name" {
  value = module.key_pair.this_key_pair_key_name
}
