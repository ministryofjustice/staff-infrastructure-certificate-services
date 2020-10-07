# MoJ Staff Infrastructure: Certificate Services

## Introduction

This project contains the Terraform code to build the Ministry of Justice's infrastructure to host PKI certificates servers.

This project is being used to create the baseline infrastructure for the PKI workstream.

The Terraform in this repository is a "once off" to create the baseline infrastructure as a tactical solution, which will then be manually managed going forward.

## Warning on tearing down infrastructure

You need to be extremely sure that your changes are not tearing EC2 instances down when running the Terraform in this repository.

If this becomes necessary, teams need to be coordinated and backups need to be taken before tearing instances down.

If you are unsure about this, please speak to someone on the technical team before running any of the Terraform in this repository.

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
- [Terraform](https://www.terraform.io/) should be installed. We recommend using a Terraform version manager such as [tfenv](https://github.com/tfutils/tfenv). Please make sure that the version of Terraform which you use on your local machine is the same as the one referenced in the file `buildspec.yml`.
- You should have AWS account access to the PKI AWS account (you can ask the team on either Slack or Microsoft Teams to sort this out for you).

### Set up aws-vault

Once aws-vault is installed, run the following two commands to create profiles for your AWS Dev and AWS Shared Services account:

- `aws-vault add moj-pttp-pki` (this will prompt you for the values of your PKI AWS account's IAM user).

### Set up MFA on your AWS account

Multi-Factor Authentication (MFA) is required on AWS accounts in this project. You will need to do this for both your Dev and Shared Services AWS accounts.

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

The infrastructure for this project should **not** be torn down at the end of each day or over the weekends.

### Useful commands

- To log in to the browser-based AWS console using `aws-vault`, run either of the following commands:
  - `aws-vault login moj-pttp-pki` to log in to the Shared Services account.

### Securing Subnets and Security Groups

- All subnets in this layout can talk to each other on all ports
- Locking down of ports is done on a per-security group level

### Remote desktop access to the Bastion host (PROD example)

- Apply the Terraform in this repository
- Run the script `get-bastion-box-passwords.sh`
- Remote desktop into the IP address shown in the file `prod_ip_address.txt`
  - Username= `Administrator`
  - Password = the value in the file `prod_password_decrypted.txt`

#### SSH-ing into Linux machines (PROD example)

This assumes that you have followed the steps above to remote desktop into the Bastion host

- Copy the file `prod_key_pair.pem` to the Bastion host
- Get the IP address of the Linux host you want to SSH into e.g. `10.180.85.4`
- From the folder containing the file `prod_key_pair.pem`, run the command `ssh ec2-user@10.180.85.4 -i prod_key_pair.pem -v`

### Things to do once this project has moved from Terraform to manual management

- Delete the Terraform S3 state bucket and DynamoDB lock table
  - The S3 state bucket contains the output variables from running the Terraform, which means that it contains passwords, key pairs etc.
