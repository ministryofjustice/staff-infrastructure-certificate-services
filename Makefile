#!make
include .env
export


fmt:
	terraform fmt -recursive

init:
	terraform init -upgrade -reconfigure \
	--backend-config="key=production/terraform.production.state"

validate:
	terraform validate

plan:
	terraform plan

apply:
	terraform apply

generate-tfvars:
	./scripts/generate_tfvars.sh	

.PHONY: fmt init validate plan apply