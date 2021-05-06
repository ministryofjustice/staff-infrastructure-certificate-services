output "private_key_pem_format" {
  value = tls_private_key.this.private_key_pem
}

output "key_name" {
  value = module.key_pair.key_pair_key_name
}
