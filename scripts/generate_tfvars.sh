#!/bin/bash

set -euo pipefail

get_outputs() {
  printf "\nGenerating tfvars file for Staff Infrastructure - Certificate-Services (Prep and Prod)\n\n"

  tfvars=`aws ssm get-parameter --with-decryption --name /staff-infrastructure-certificate-services/terraform.tfvars | jq -r .Parameter.Value`
}

get_outputs

cat <<EOF > terraform.tfvars
${tfvars}
EOF

echo "Take a look at your terraform.tfvars file ...!"
read -n 1 -r -s -p $'Press enter to continue...\n'