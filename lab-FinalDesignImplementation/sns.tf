resource "aws_sns_topic" "scaling_notifications" {
  name = "scaling-notifications"
}

resource "aws_sns_topic_subscription" "email_subscription" {
  topic_arn = aws_sns_topic.scaling_notifications.arn
  protocol  = "email"
  endpoint  = var.notification_email
}

# resource "aws_autoscaling_notification" "frontend_asg_notifications" {
#   group_names = [aws_autoscaling_group.frontend_asg.name]
#   topic_arn   = aws_sns_topic.scaling_notifications.arn
#   notifications = [
#     "autoscaling:EC2_INSTANCE_LAUNCH",
#     "autoscaling:EC2_INSTANCE_TERMINATE",
#     "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
#     "autoscaling:EC2_INSTANCE_TERMINATE_ERROR"
#   ]
# }

resource "aws_autoscaling_notification" "backend_asg_notifications" {
  group_names = [aws_autoscaling_group.backend_asg.name]
  topic_arn   = aws_sns_topic.scaling_notifications.arn
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR"
  ]
}
