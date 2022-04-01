provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}
# 証明書発行リクエスト
# NOTE: 今回はNameServerにRoute53を利用しないため発行後の検証作業などは手動で行う
resource "aws_acm_certificate" "cert" {
  domain_name               = "*.${var.root_domain}"
  subject_alternative_names = [var.root_domain]
  validation_method         = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "cert_cloudfront" {
  domain_name       = "cdn.${var.root_domain}"
  validation_method = "DNS"
  provider          = aws.virginia
  lifecycle {
    create_before_destroy = true
  }
}
