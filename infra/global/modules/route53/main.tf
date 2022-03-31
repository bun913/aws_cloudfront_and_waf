# ホストゾーンだけは破壊されたくないのでGlobalで作成(破壊するとネームサーバーが変更になってしまう)
resource "aws_route53_zone" "main" {
  name = var.root_domain
  tags = var.tags
}
