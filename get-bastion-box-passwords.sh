clear

rm pre_prod_key_pair.pem -f
rm prod_key_pair.pem -f

printf "\nNote that it is normal for AWS Vault to ask for your vault-unlock passphrase multiple times during the execution of this script\n\n"

printf "Fetching private keys...\n\n"
aws-vault exec moj-pttp-pki -- terraform output pre_prod_private_key_pem_format > pre_prod_key_pair.pem
printf "\n"
aws-vault exec moj-pttp-pki -- terraform output prod_private_key_pem_format > prod_key_pair.pem

printf "\n\nRunning chmod on private keys\n"
chmod 400 pre_prod_key_pair.pem
chmod 400 prod_key_pair.pem

printf "\nFetching encrypted passwords...\n\n"
aws-vault exec moj-pttp-pki -- terraform output pre_prod_ec2_bastion_password_data > pre_prod_password_encrypted.txt
printf "\n"
aws-vault exec moj-pttp-pki -- terraform output prod_ec2_bastion_password_data > prod_password_encrypted.txt

printf "\n\nBase64 decoding encrypted passwords...\n"
cat ./pre_prod_password_encrypted.txt | base64 -d > pre_prod_password_encrypted.bin
cat ./prod_password_encrypted.txt | base64 -d > prod_password_encrypted.bin

printf "\nDecrypting passwords...\n"
openssl rsautl -decrypt -in ./pre_prod_password_encrypted.bin -out ./prep_password_decrypted.txt -inkey ./pre_prod_key_pair.pem
openssl rsautl -decrypt -in ./prod_password_encrypted.bin -out ./prod_password_decrypted.txt -inkey ./prod_key_pair.pem

printf "\nPREP IP:\n"
aws-vault exec moj-pttp-pki -- terraform output pre_prod_ec2_bastion_public_ip > pre_prod_ip_address.txt
cat pre_prod_ip_address.txt
printf "\nPREP password:\n"
cat prep_password_decrypted.txt

printf "\n\nPROD IP:\n"
aws-vault exec moj-pttp-pki -- terraform output prod_ec2_bastion_public_ip > prod_ip_address.txt
cat prod_ip_address.txt
printf "\nPROD password:\n"
cat prod_password_decrypted.txt

printf "\n\nRemoving temporary files...\n"
rm pre_prod_key_pair.pem -f
rm prod_key_pair.pem -f

rm pre_prod_password_encrypted.txt -f
rm prod_password_encrypted.txt -f

rm pre_prod_password_encrypted.bin -f
rm prod_password_encrypted.bin -f

printf "\nDone!\n"
