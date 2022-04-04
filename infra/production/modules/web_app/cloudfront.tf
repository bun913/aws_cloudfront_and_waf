/*
    S3をOriginにする際に設定が必要なPolicy
 */
# キャッシュポリシー
data "aws_cloudfront_cache_policy" "asset" {
  name = "Managed-Elemental-MediaPackage"
}
# オリジンリクエストポリシー
data "aws_cloudfront_origin_request_policy" "asset" {
  name = "Managed-CORS-S3Origin"
}
# レスポンスヘッダーポリシー
resource "aws_cloudfront_response_headers_policy" "asset" {
  name    = "${var.prefix}-response-headers-policy"
  comment = "Allow from limited origins"

  cors_config {
    access_control_allow_credentials = false

    access_control_allow_headers {
      items = ["*"]
    }

    access_control_allow_methods {
      items = ["GET", "HEAD"]
    }

    access_control_allow_origins {
      items = [
        "https://alb.${var.root_domain}",
      ]
    }

    origin_override = true
  }
}

# TODO: S3を作ってい /static/ 以下のパスをS3にルーティングするように設定する

# Cloudfront
resource "aws_cloudfront_distribution" "asset" {
  enabled = true
  aliases = [
    "cdn.${var.root_domain}"
  ]
  web_acl_id = aws_wafv2_web_acl.main.arn
  origin {
    domain_name = "alb.${var.root_domain}"
    origin_id   = aws_lb.app.id
    custom_origin_config {
      http_port                = 80
      https_port               = 443
      origin_keepalive_timeout = 5
      origin_protocol_policy   = "https-only"
      origin_read_timeout      = 60
      origin_ssl_protocols     = ["TLSv1", "TLSv1.1", "TLSv1.2"]
    }
    /* s3_origin_config { */
    /*   origin_access_identity = aws_cloudfront_origin_access_identity.oai.cloudfront_access_identity_path */
    /* } */
  }
  viewer_certificate {
    cloudfront_default_certificate = false
    acm_certificate_arn            = var.cloudfront_acm_arn
    minimum_protocol_version       = "TLSv1"
    ssl_support_method             = "sni-only"
  }
  default_cache_behavior {
    allowed_methods  = ["HEAD", "DELETE", "POST", "GET", "OPTIONS", "PUT", "PATCH"]
    cached_methods   = ["HEAD", "GET", "OPTIONS"]
    target_origin_id = aws_lb.app.id

    forwarded_values {
      query_string = true
      cookies {
        forward = "all"
      }
      headers = ["*"]
      /* headers = ["Accept", "Accept-Language", "Authorization", "CloudFront-Forwarded-Proto", "Host", "Origin", "Referer", "User-agent"] */
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 0
    max_ttl                = 0
  }
  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["JP"]
    }
  }
}
