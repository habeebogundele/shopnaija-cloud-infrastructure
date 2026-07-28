resource "aws_cloudwatch_metric_alarm" "ec2_cpu" {

  alarm_name = "HighEC2CPU"

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 2

  metric_name = "CPUUtilization"

  namespace = "AWS/EC2"

  period = 300

  statistic = "Average"

  threshold = 80

}

resource "aws_cloudwatch_metric_alarm" "rds_cpu" {

  alarm_name = "HighRDSCPU"

  namespace = "AWS/RDS"

  metric_name = "CPUUtilization"

  threshold = 70

  comparison_operator = "GreaterThanThreshold"

  evaluation_periods = 2

  statistic = "Average"

  period = 300

}

