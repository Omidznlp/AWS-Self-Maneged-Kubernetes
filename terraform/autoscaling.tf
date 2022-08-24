#AutoScaling Launch Configuration
resource "aws_launch_template" "template-master-instance" {
  name_prefix     = "master"
  image_id        = lookup(var.awsprops, "ami")
  instance_type   = "t3.medium"
  vpc_security_group_ids = ["${aws_security_group.custom-sg-public.id}"]
  key_name        = lookup(var.awsprops, "keyname")
  user_data = filebase64("install_docker_kubernets.sh")
}
resource "aws_launch_template" "template-slave-instance" {
  name_prefix     = "slave"
  image_id        = lookup(var.awsprops, "ami")
  instance_type   = "t3.medium"
  key_name        = lookup(var.awsprops, "keyname")
  vpc_security_group_ids = ["${aws_security_group.custom-sg-private.id}"]
  user_data = filebase64("install_docker_kubernets.sh")
}
#Autoscaling Group
resource "aws_autoscaling_group" "master-autoscaling" {
  name                      = "master-autoscaling"
  vpc_zone_identifier       = [aws_subnet.subnet-public-1.id,aws_subnet.subnet-public-2.id]
  target_group_arns         = ["${aws_lb_target_group.alb-tg.arn}"]
  min_size                  = 1
  desired_capacity          = 1
  max_size                  = 2
  health_check_type         = "EC2"
  health_check_grace_period = 200
  force_delete              = true
  launch_template {
    id      = aws_launch_template.template-master-instance.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "master-node"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "slave-autoscaling" {
  name                      = "slave-autoscaling"
  vpc_zone_identifier       = [aws_subnet.subnet-private-1.id,aws_subnet.subnet-private-2.id]
  min_size                  = 2
  desired_capacity          = 2
  max_size                  = 3
  health_check_type         = "EC2"
  health_check_grace_period = 200
  force_delete              = true
  launch_template {
    id      = aws_launch_template.template-slave-instance.id
    version = "$Latest"
  }
  tag {
    key                 = "Name"
    value               = "worker-node"
    propagate_at_launch = true
  }

}
#Autoscaling Configuration policy - Scaling Alarm
resource "aws_autoscaling_policy" "master-cpu-policy" {
  name                   = "maaster-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.master-autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "200"
  policy_type            = "SimpleScaling"
}
resource "aws_autoscaling_policy" "slave-cpu-policy" {
  name                   = "slave-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.slave-autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "1"
  cooldown               = "200"
  policy_type            = "SimpleScaling"
}
#Auto scaling Cloud Watch Monitoring
resource "aws_cloudwatch_metric_alarm" "master-cpu-alarm" {
  alarm_name          = "master-cpu-alarm"
  alarm_description   = "Alarm once CPU Uses Increase"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.master-autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.master-cpu-policy.arn]
}
resource "aws_cloudwatch_metric_alarm" "slave-cpu-alarm" {
  alarm_name          = "slave-cpu-alarm"
  alarm_description   = "Alarm once CPU Uses Increase"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "30"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.slave-autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.slave-cpu-policy.arn]
}
#Auto Descaling Policy
resource "aws_autoscaling_policy" "master-cpu-policy-scaledown" {
  name                   = "master-cpu-policy-scaledown"
  autoscaling_group_name = aws_autoscaling_group.master-autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "200"
  policy_type            = "SimpleScaling"
}
resource "aws_autoscaling_policy" "slave-cpu-policy-scaledown" {
  name                   = "slave-cpu-policy-scaledown"
  autoscaling_group_name = aws_autoscaling_group.slave-autoscaling.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = "-1"
  cooldown               = "300"
  policy_type            = "SimpleScaling"
}
#Auto descaling cloud watch 
resource "aws_cloudwatch_metric_alarm" "master-cpu-alarm-scaledown" {
  alarm_name          = "master-cpu-alarm-scaledown"
  alarm_description   = "Alarm once CPU Uses Decrease"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "3"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.master-autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.master-cpu-policy-scaledown.arn]
}
resource "aws_cloudwatch_metric_alarm" "slave-cpu-alarm-scaledown" {
  alarm_name          = "slave-cpu-alarm-scaledown"
  alarm_description   = "Alarm once CPU Uses Decrease"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "4"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "10"

  dimensions = {
    "AutoScalingGroupName" = aws_autoscaling_group.slave-autoscaling.name
  }

  actions_enabled = true
  alarm_actions   = [aws_autoscaling_policy.slave-cpu-policy-scaledown.arn]
}