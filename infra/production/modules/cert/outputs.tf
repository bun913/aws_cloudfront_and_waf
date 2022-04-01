output "acm_alb_arn" {
  value = aws_acm_certificate.cert.arn
}
output "acm_cloudfront_arn" {
  value = aws_acm_certificate.cert_cloudfront.arn
}
