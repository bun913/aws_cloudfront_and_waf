resource "aws_route53_zone" "main" {
  name = var.root_domain
  tags = var.tags
}
# NOTE: ドメイン取得元でネームサーバーを↑のホストゾーンに向ける必要がある
# ドメインをRoute53に移管するなどの対応を検討
resource "aws_route53_record" "alb" {
  zone_id = var.host_zone_id
  name    = var.root_domain
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}
# ACMのドメイン検証
resource "aws_route53_record" "cert_validation_main" {
  for_each = {
    for dvo in var.acm_main_domain_valid_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  ttl             = "300"

  zone_id = var.host_zone_id
}

resource "aws_route53_record" "cert_validation_sub" {
  for_each = {
    for dvo in var.acm_sub_domain_valid_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  type            = each.value.type
  ttl             = "300"

  zone_id = var.host_zone_id
}

resource "aws_route53_record" "cognito_auth_cname" {
  allow_overwrite = true
  name            = "auth.${var.root_domain}"
  records         = [var.congnito_domain_cname_value]
  type            = "CNAME"
  ttl             = "300"

  zone_id = var.host_zone_id
}
