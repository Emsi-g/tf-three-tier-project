output "alb_cert_arn" {
    value = aws_acm_certificate.alb_cert.arn
}

output "cf_cert_arn" {
    value = aws_acm_certificate.cf_cert.arn
}