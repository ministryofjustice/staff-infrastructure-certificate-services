variable "alarm_name" {
  description = "The name for the alarm that will appear in the EC2 console"
  type        = string
}

variable "alarm_description" {
  description = "Description of the alarm"
  type        = string
}

variable "comparison_operator" {
  description = "The arithmetic operation to use when comparing the specified Statistic and Threshold."
  type        = string
}

variable "evaluation_periods" {
  description = "The number of periods over which data is compared to the specified threshold."
  type        = number
}

variable "threshold" {
  description = "The value against which the specified statistic is compared."
  type        = number
}

variable "period" {
  description = "The period in seconds over which the specified statistic is applied. Valid values are 10, 30, or any multiple of 60."
  type        = number
}

variable "unit" {
  description = " The unit for the alarm's associated metric."
  type        = string
}

variable "metric_name" {
  description = "The name for the alarm's associated metric."
  type        = string
}

variable "statistic" {
  description = "The statistic to apply to the alarm's associated metric. Either of the following is supported: SampleCount, Average, Sum, Minimum, Maximum."
  type        = string
}

variable "alarm_actions" {
  description = "The list of actions to execute when this alarm transitions into an ALARM state from any other state."
  type        = list(string)
  default     = null
}
