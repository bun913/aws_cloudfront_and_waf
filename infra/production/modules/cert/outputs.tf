output "acm_arn" {
  value = aws_acm_certificate.cert.arn
}
output "acm_sub_arn" {
  value = aws_acm_certificate.cert_sub.arn
}
output "acm_main_domain_valid_options" {
  value = aws_acm_certificate.cert.domain_validation_options
}
output "acm_sub_domain_valid_options" {
  value = aws_acm_certificate.cert_sub.domain_validation_options
}
