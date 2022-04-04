resource "aws_cloudwatch_log_group" "app" {
  name              = "${var.prefix}-app"
  retention_in_days = 1
}

resource "aws_cloudwatch_log_group" "waf" {
  # prefixがaws-waf-logsから始まる必要がある
  name              = "aws-waf-logs-${var.prefix}"
  retention_in_days = 1
  provider          = aws.virginia
}
