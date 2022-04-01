resource "aws_cloudwatch_log_group" "app" {
  name              = "${var.prefix}-app"
  retention_in_days = 1
}
