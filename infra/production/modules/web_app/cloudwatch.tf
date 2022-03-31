resource "aws_cloudwatch_log_group" "app" {
  name              = "${var.project}-app"
  tags              = var.tags
  retention_in_days = 90
}
