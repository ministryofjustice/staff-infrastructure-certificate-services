# MoJ Staff Infrastructure: Certificate Services

[![repo standards badge](https://img.shields.io/badge/dynamic/json?color=blue&style=flat&logo=github&labelColor=32393F&label=MoJ%20Compliant&query=%24.result&url=https%3A%2F%2Foperations-engineering-reports.cloud-platform.service.justice.gov.uk%2Fapi%2Fv1%2Fcompliant_public_repositories%2Fstaff-infrastructure-certificate-services)](https://operations-engineering-reports.cloud-platform.service.justice.gov.uk/public-github-repositories.html#staff-infrastructure-certificate-services "Link to report") [![Terraform CI](https://github.com/ministryofjustice/staff-infrastructure-certificate-services/actions/workflows/terraform-ci.yaml/badge.svg)](https://github.com/ministryofjustice/staff-infrastructure-certificate-services/actions/workflows/terraform-ci.yaml)

## Introduction

This project contains the Terraform code to build the Ministry of Justice's infrastructure to host PKI certificates servers.

The Terraform in this repository is a "once off" to create the baseline infrastructure as a tactical solution, which will then be manually managed going forward.

## Warning on tearing down infrastructure

You need to be extremely sure that your changes are not tearing EC2 instances down when running the Terraform in this repository.
![badge](https://user-images.githubusercontent.com/41325732/193793492-4ecd66a1-5b5b-40dc-88d7-f68541ce7d24.svg)

If this becomes necessary, teams need to be coordinated and backups need to be taken before tearing instances down.

If you are unsure about this, please speak to someone on the technical team before running any of the Terraform in this repository.
![badge](https://user-images.githubusercontent.com/41325732/193788841-245aace7-9b8d-4c92-9652-ded4690f4098.svg)

## Terraform State Management

The Terraform state for this project is created by running the Terraform files in the folder `create-terraform-state-infrastructure`.

This has already been done, and you should **not** run these files again.

## Architecture

The high-level design for this project can be found on the wiki at [this link](https://dsdmoj.atlassian.net/wiki/spaces/PTTPWIK/pages/2382102667/Public+Key+Infrastructure).

The detailed design documents for this project can be found in Microsoft Teams at [this link](https://teams.microsoft.com/_#/files/General?threadId=19%3Ab744b63ceeb9487d9886ccfc61a252d2%40thread.tacv2&ctx=channel&context=Tech%2520Designs%2520-%2520Documents&rootfolder=%252Fsites%252FMoJPKIBuild%252FShared%2520Documents%252FGeneral%252FTech%2520Designs%2520-%2520Documents).

## Getting started

### Prerequisites

- The [AWS CLI](https://aws.amazon.com/cli/) should be installed.
- [aws-vault](https://github.com/99designs/aws-vault) should be installed. This is used to easily manage and switch between AWS account profiles on the command line.
- [Terraform](https://www.terraform.io/) should be installed. We recommend using a Terraform version manager such as [tfenv](https://github.com/tfutils/tfenv). Please make sure that you are using `Terraform v0.12.29`.
- You should have AWS account access to the PKI AWS account (you can ask the team on either Slack or Microsoft Teams to sort this out for you).

### Set up aws-vault

Once aws-vault is installed, run the following command to create the profile for your PKI AWS account: `aws-vault add moj-pttp-pki`

This will prompt you for the values of your PKI AWS account's IAM user.

### Set up MFA on your AWS account

Multi-Factor Authentication (MFA) is required on the AWS account on this project.

The steps to set this up are as follows:

- Navigate to the AWS console for a given account.
- Click on "IAM" under Services in the AWS console.
- Click on "Users" in the IAM menu.
- Find your username within the list and click on it.
- Select the security credentials tab, then assign an MFA device using the "Virtual MFA device" option (follow the on-screen instructions for this step).
- Edit your local `~/.aws/config` file with the key value pair of `mfa_serial=<iam_role_from_mfa_device>` for each of your accounts. The value for `<iam_role_from_mfa_device>` can be found in the AWS console on your IAM user details page, under "Assigned MFA device". Ensure that you remove the text "(Virtual)" from the end of key value pair's value when you edit this file.

### Running the code

Run the following commands to get the code running on your machine:

- Run `aws-vault exec moj-pttp-pki -- terraform init` (if you are prompted to bring across workspaces, say yes).
- If it asks you to enter a value for "The path to the state file inside the bucket", enter the value `terraform.development.state`
- Edit your aws config file (usually found in `~/.aws/config`) to include the key value pair of `region=eu-west-2` for the `profile moj-pttp-pki` workspace.
- Run `aws-vault exec moj-pttp-pki -- terraform plan` and check that for an output. If it appears as correct terraform output, run `aws-vault exec moj-pttp-pki -- terraform apply`.

### Tearing down infrastructure

The infrastructure for this project should **not** be torn down.

### Useful commands

To log in to the browser-based AWS console using `aws-vault`, run the following command: `aws-vault login moj-pttp-pki`

### Remote desktop access to the Bastion host (PROD example)

- Apply the Terraform in this repository
- Run the script `get-bastion-box-passwords.sh`
- Remote desktop into the IP address shown in the file `prod_ip_address.txt`
  - Username = `Administrator`
  - Password = the value in the file `prod_password_decrypted.txt`

#### SSH-ing into Linux machines (PROD example)

This assumes that you have followed the steps above to remote desktop into the Bastion host.

- Copy the file `prod_key_pair.pem` to the Bastion host
- Get the IP address of the Linux host you want to SSH into e.g. `10.180.85.4`
- From the folder containing the file `prod_key_pair.pem`, run the command `ssh ec2-user@10.180.85.4 -i prod_key_pair.pem -v`

### Things to do once this project has moved from Terraform to manual management

- Delete the Terraform S3 state bucket and DynamoDB lock table.
  - The S3 state bucket contains the output variables from running the Terraform, which means that it contains passwords, key pairs etc.
