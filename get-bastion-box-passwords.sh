clear

rm pre_prod_key_pair.pem -f
rm prod_key_pair.pem -f

printf "\nIf you are using AWS Vault, note that it is normal to be asked for your vault-unlock passphrase multiple times during the execution of this script\n\n"

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
aws-vault exec moj-pttp-pki -- terraform output pre_prod_ec2_bastion_public_ip
printf "PREP password:\n"
cat prep_password_decrypted.txt

printf "\n\nPROD IP:\n"
aws-vault exec moj-pttp-pki -- terraform output prod_ec2_bastion_public_ip
printf "PROD password:\n"
cat prod_password_decrypted.txt

printf "\n\nRemoving temporary files...\n"
rm pre_prod_key_pair.pem -f
rm prod_key_pair.pem -f

rm pre_prod_password_encrypted.txt -f
rm prod_password_encrypted.txt -f

rm pre_prod_password_encrypted.bin -f
rm prod_password_encrypted.bin -f

printf "\nDone!\n"
