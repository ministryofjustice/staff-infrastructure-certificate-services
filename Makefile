#!make
include .env
export


fmt:
	terraform fmt -recursive

init:
	aws-vault exec $$AWS_VAULT_PROFILE -- terraform init -upgrade -reconfigure \
	--backend-config="key=production/terraform.production.state"

validate:
	aws-vault exec $$AWS_VAULT_PROFILE -- terraform validate

plan:
	aws-vault exec $$AWS_VAULT_PROFILE -- terraform plan

apply:
	aws-vault exec $$AWS_VAULT_PROFILE -- terraform apply

.PHONY: fmt init validate plan apply