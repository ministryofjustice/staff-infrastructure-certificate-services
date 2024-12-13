module "metric_alarm" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 3.0"

  alarm_name          = var.alarm_name
  alarm_description   = var.alarm_description
  comparison_operator = var.comparison_operator
  evaluation_periods  = var.evaluation_periods
  threshold           = var.threshold
  period              = var.period
  unit                = var.unit

  namespace   = "AWS/EC2"
  metric_name = var.metric_name
  statistic   = var.statistic

  alarm_actions = [module.sns_topic.sns_topic_arn]

  dimensions = {
    InstanceId = var.instance_id
  }
}
