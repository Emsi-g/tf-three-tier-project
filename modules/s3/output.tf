output "s3_bucket_regional_dn" {
    value = aws_s3_bucket.s3_bucket.bucket_regional_domain_name
}