# MoJ Staff Infrastructure: Certificate Services

## Introduction

This project contains the Terraform code to build the Ministry of Justice's infrastructure to host PKI certificates servers.

This project is being used to create the baseline infrastructure for the PKI workstream.

The Terraform in this repository is a "once off" to create the baseline infrastructure as a tactical solution, which will then be manually managed going forward.

The Terraform in this repository can be run in 2 different contexts:

## Architecture

`TODO: add a link to the architecture diagram here`

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
- Create a file named `terraform.tfvars` in the root of the project and populate it with the default developer Terraform settings. # TODO: figure out how to do this in PKI
- Edit your aws config file (usually found in `~/.aws/config`) to include the key value pair of `region=eu-west-2` for the `profile moj-pttp-pki` workspace.
- Run `aws-vault exec moj-pttp-pki -- terraform plan` and check that for an output. If it appears as correct terraform output, run `aws-vault exec moj-pttp-pki -- terraform apply`.

### Tearing down infrastructure

The infrastructure for this project should **not** be torn down at the end of each day or over the weekends.

### Useful commands

- To log in to the browser-based AWS console using `aws-vault`, run either of the following commands:
  - `aws-vault login moj-pttp-pki` to log in to the Shared Services account.
