terraform {
  required_providers {
    aws = {}
  }
}

module "lambda_scheduler_stop" {
  source                         = "diodonfrost/lambda-scheduler-stop-start/aws"
  version                        = "3.1.3"
  name                           = "ec2_prep_pki_stop"
  cloudwatch_schedule_expression = "cron(0 19 ? * MON-FRI *)"
  schedule_action                = "stop"
  ec2_schedule                   = "true"
  cloudwatch_alarm_schedule      = "false"
  scheduler_tag = {
    key   = "scheduledStop"
    value = "true"
  }
}

module "lambda_scheduler_start_ldap" {
  source                         = "diodonfrost/lambda-scheduler-stop-start/aws"
  version                        = "3.1.3"
  name                           = "ec2_prep_pki_ldap_start"
  cloudwatch_schedule_expression = "cron(00 06 ? * MON-FRI *)"
  schedule_action                = "start"
  ec2_schedule                   = "true"
  cloudwatch_alarm_schedule      = "false"
  scheduler_tag = {
    key   = "scheduledStart"
    value = "true-prep-ldap-schedule"
  }
}

module "lambda_scheduler_start_issuing_ca" {
  source                         = "diodonfrost/lambda-scheduler-stop-start/aws"
  version                        = "3.1.3"
  name                           = "ec2_prep_pki_issuing_ca_start"
  cloudwatch_schedule_expression = "cron(01 06 ? * MON-FRI *)"
  schedule_action                = "start"
  ec2_schedule                   = "true"
  cloudwatch_alarm_schedule      = "false"
  scheduler_tag = {
    key   = "scheduledStart"
    value = "true-prep-issuing-ca-schedule"
  }
}

module "lambda_scheduler_start_ra_app" {
  source                         = "diodonfrost/lambda-scheduler-stop-start/aws"
  version                        = "3.1.3"
  name                           = "ec2_prep_pki_ra_app_start"
  cloudwatch_schedule_expression = "cron(02 06 ? * MON-FRI *)"
  schedule_action                = "start"
  ec2_schedule                   = "true"
  cloudwatch_alarm_schedule      = "false"
  scheduler_tag = {
    key   = "scheduledStart"
    value = "true-prep-ra-app-schedule"
  }
}

module "lambda_scheduler_start" {
  source                         = "diodonfrost/lambda-scheduler-stop-start/aws"
  version                        = "3.1.3"
  name                           = "ec2_prep_pki_start"
  cloudwatch_schedule_expression = "cron(04 06 ? * MON-FRI *)"
  schedule_action                = "start"
  ec2_schedule                   = "true"
  cloudwatch_alarm_schedule      = "false"
  scheduler_tag = {
    key   = "scheduledStart"
    value = "true"
  }
}