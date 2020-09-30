clear

rm prep.pem -f
rm prod.pem -f

printf "\nFetching private keys...\n\n"
aws-vault exec moj-pttp-pki -- terraform output pre_prod_private_key_pem_format > prep.pem
printf "\n"
aws-vault exec moj-pttp-pki -- terraform output prod_private_key_pem_format > prod.pem

printf "\n\nRunning chmod on private keys\n"
chmod 400 prep.pem
chmod 400 prod.pem

printf "\nFetching encrypted passwords...\n\n"
aws-vault exec moj-pttp-pki -- terraform output pre_prod_ec2_bastion_password_data > prep_password_encrypted.txt
printf "\n"
aws-vault exec moj-pttp-pki -- terraform output prod_ec2_bastion_password_data > prod_password_encrypted.txt

printf "\n\nBase64 decoding encrypted passwords...\n"
cat ./prep_password_encrypted.txt | base64 -d > prep_password_encrypted.bin
cat ./prod_password_encrypted.txt | base64 -d > prod_password_encrypted.bin

printf "\nDecrypting passwords...\n"
openssl rsautl -decrypt -in ./prep_password_encrypted.bin -out ./prep_password_decrypted.txt -inkey ./prep.pem
openssl rsautl -decrypt -in ./prod_password_encrypted.bin -out ./prod_password_decrypted.txt -inkey ./prod.pem

printf "\nPREP IP:\n"
aws-vault exec moj-pttp-pki -- terraform output pre_prod_ec2_bastion_eip
printf "PREP password:\n"
cat prep_password_decrypted.txt

printf "\n\nPROD IP:\n"
aws-vault exec moj-pttp-pki -- terraform output prod_ec2_bastion_eip
printf "PROD password:\n"
cat prod_password_decrypted.txt

printf "\n\nDone!\n"
