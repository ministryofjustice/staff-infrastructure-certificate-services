module "sg_ra_web_server" {
  source = ".././sg"

  vpc_id                     = module.pki_vpc.vpc_id
  security_group_description = "${var.prefix}-ra-web-server-security-group"

  # Bastion
  ingress_with_cidr_blocks = [
    {
      from_port   = local.ssh_port
      to_port     = local.ssh_port
      protocol    = local.tcp_protocol
      description = "Allow SSH from the bastion host"
      cidr_blocks = local.cidr_bastion_host
    },

    # RA app server
    {
      from_port   = 8010
      to_port     = 8010
      protocol    = local.tcp_protocol
      description = "Allow RA web server to talk to RA app server"
      cidr_blocks = local.cidr_ra_app_server
    },
    {
      from_port   = 8013
      to_port     = 8013
      protocol    = local.tcp_protocol
      description = "Allow RA web server to talk to RA app server"
      cidr_blocks = local.cidr_ra_app_server
    },
    {
      from_port   = 9039
      to_port     = 9039
      protocol    = local.tcp_protocol
      description = "Allow RA web server to talk to RA app server"
      cidr_blocks = local.cidr_ra_app_server
    },

    # Reverse proxy
    {
      from_port   = 8030
      to_port     = 8030
      protocol    = local.tcp_protocol
      description = "Allow RA web server to talk to reverse proxy"
      cidr_blocks = local.cidr_reverse_proxy
    },

    # Public Internet
    {
      from_port   = local.http_port
      to_port     = local.http_port
      protocol    = local.tcp_protocol
      description = "Allow RA web server to access the public Internet"
      cidr_blocks = local.public_internet_cidr_block
    },
    {
      from_port   = local.https_port
      to_port     = local.https_port
      protocol    = local.tcp_protocol
      description = "Allow RA web server to access the public Internet"
      cidr_blocks = local.public_internet_cidr_block
    },

    # Inter VPC Traffic
    {
      ##TO-CLEAR-UP
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = "#TO-CLEAR-UP# Permit all egress traffic"
      cidr_blocks = local.cidr_block_vpc
    },

    # Global Protect
    {
      from_port   = 21443
      to_port     = 21443
      protocol    = local.tcp_protocol
      description = "Allow Global Protect Users to CSRES-Request"
      cidr_blocks = var.gp_client_prod_cidr_block
    },
    {
      from_port   = 22443
      to_port     = 22443
      protocol    = local.tcp_protocol
      description = "Allow Global Protect Users to CSRES-Approve"
      cidr_blocks = var.gp_client_prod_cidr_block
    },
    {
      from_port   = 9443
      to_port     = 9443
      protocol    = local.tcp_protocol
      description = "Allow Global Protect Users to UMS"
      cidr_blocks = var.gp_client_prod_cidr_block
    },

    # Azure Landing Zone - Private Class A
    {
      from_port   = 8030
      to_port     = 8030
      protocol    = local.tcp_protocol
      description = "Allow traffic from ALZ"
      cidr_blocks = local.cidr_private_a
    },
  ]

  egress_with_cidr_blocks = [
    # RA app server
    {
      from_port   = 8010
      to_port     = 8010
      protocol    = local.tcp_protocol
      description = "Allow RA web server to talk to RA app server"
      cidr_blocks = local.cidr_ra_app_server
    },
    {
      from_port   = 8013
      to_port     = 8013
      protocol    = local.tcp_protocol
      description = "Allow RA web server to talk to RA app server"
      cidr_blocks = local.cidr_ra_app_server
    },
    {
      from_port   = 9039
      to_port     = 9039
      protocol    = local.tcp_protocol
      description = "Allow RA web server to talk to RA app server"
      cidr_blocks = local.cidr_ra_app_server
    },

    # Reverse proxy
    {
      from_port   = 8030
      to_port     = 8030
      protocol    = local.tcp_protocol
      description = "Allow RA web server to talk to reverse proxy"
      cidr_blocks = local.cidr_reverse_proxy
    },

    # Public Internet
    {
      from_port   = local.http_port
      to_port     = local.http_port
      protocol    = local.tcp_protocol
      description = "Allow RA web server to access the public Internet"
      cidr_blocks = local.public_internet_cidr_block
    },
    {
      from_port   = local.https_port
      to_port     = local.https_port
      protocol    = local.tcp_protocol
      description = "Allow RA web server to access the public Internet"
      cidr_blocks = local.public_internet_cidr_block
    },
    {
      ##TO-CLEAR-UP
      from_port   = 0
      to_port     = 0
      protocol    = -1
      description = "#TO-CLEAR-UP# Permit all egress traffic"
      cidr_blocks = local.public_internet_cidr_block
    },
  ]

  tags = var.tags
}

module "ec2_ra_web_server" {
  source = ".././ec2"

  ami                         = local.ami_rhel_7_6_x64
  instance_type               = local.instance_type_linux
  subnet_id                   = module.pki_vpc.private_subnet_private_ra_zone_id
  private_ip                  = local.ip_ra_web_server
  key_name                    = module.pki_key_pair.key_name
  vpc_security_group_ids      = [module.sg_ra_web_server.this_security_group_id]
  associate_public_ip_address = false
  get_password_data           = false
  server_description          = "${var.prefix}-ra-web-server"
  scheduledStop               = "false"
  scheduledStart              = "false"

  root_block_device = [
    {
      volume_size = 40
    },
  ]

  tags = merge(
    var.tags,
    {
      Environment = var.environment_description
    },
  )
}

module "ma_system_status_check_ra_web_server" {
  source = ".././ec2alarms"

  alarm_name          = "${var.prefix}-system-status-check-ra-web-server-alarm"
  alarm_description   = "Check for system status check errors."
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  threshold           = 1
  period              = 60
  unit                = "Count"

  metric_name = "StatusCheckFailed_System"
  statistic   = "Maximum"

  instance_id   = module.ec2_ra_web_server.instance_id[0]
  alarm_actions = ["arn:aws:sns:${var.region_id}:${data.aws_caller_identity.current.account_id}:ec2-alarm-sns"]
}

module "ma_instance_status_check_ra_web_server" {
  source = ".././ec2alarms"

  alarm_name          = "${var.prefix}-instance-status-check-ra-web-server-alarm"
  alarm_description   = "Check for instance status check errors."
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  datapoints_to_alarm = 1
  threshold           = 1
  period              = 60
  unit                = "Count"

  metric_name = "StatusCheckFailed_Instance"
  statistic   = "Maximum"

  instance_id   = module.ec2_ra_web_server.instance_id[0]
  alarm_actions = ["arn:aws:sns:${var.region_id}:${data.aws_caller_identity.current.account_id}:ec2-alarm-sns"]
}

module "ma_cpu_utilization_status_check_ra_web_server" {
  source = ".././ec2alarms"

  alarm_name          = "${var.prefix}-cpu-utilization-ra-web-server-alarm"
  alarm_description   = "Alarm when CPU utilization is greater than or equal to 15%."
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  datapoints_to_alarm = 2
  threshold           = 1
  period              = 300 # 5 minutes
  unit                = "Count"

  metric_name = "CPUUtilization"
  statistic   = "Average"

  instance_id   = module.ec2_ra_web_server.instance_id[0]
  alarm_actions = ["arn:aws:sns:${var.region_id}:${data.aws_caller_identity.current.account_id}:ec2-alarm-sns"]
}

module "ma_network_packets_in_status_check_ra_web_server" {
  source = ".././ec2alarms"

  alarm_name          = "${var.prefix}-network-packets-in-ra-web-server-alarm"
  alarm_description   = "Alarm when incoming network packets is greater than or equal to 1500."
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  datapoints_to_alarm = 2
  threshold           = 3000
  period              = 300 # 5 minutes
  unit                = "Count"

  metric_name = "NetworkPacketsIn"
  statistic   = "Average"

  instance_id   = module.ec2_ra_web_server.instance_id[0]
  alarm_actions = ["arn:aws:sns:${var.region_id}:${data.aws_caller_identity.current.account_id}:ec2-alarm-sns"]
}
