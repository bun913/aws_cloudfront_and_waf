# globalでホストゾーンを作成済みである必要がある
resource "aws_route53_record" "alb" {
  zone_id = var.host_zone_id
  name    = "alb.${var.root_domain}"
  type    = "A"

  alias {
    name                   = aws_lb.app.dns_name
    zone_id                = aws_lb.app.zone_id
    evaluate_target_health = true
  }
}

# CloudFrontのレコード設定
resource "aws_route53_record" "cdn" {
  zone_id = var.host_zone_id
  name    = "cdn.${var.root_domain}"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.asset.domain_name
    zone_id                = aws_cloudfront_distribution.asset.hosted_zone_id
    evaluate_target_health = false
  }
}
