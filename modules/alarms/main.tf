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

  namespace   = var.namespace
  metric_name = var.metric_name
  statistic   = var.statistic

  alarm_actions = var.alarm_actions

  dimensions = {
    InstanceId = var.instance_id
  }
}
