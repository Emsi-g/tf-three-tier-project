output "alb_cf_dist_arn" {
    value = aws_cloudfront_distribution.alb_cf_dist.arn
}

output "alb_cf_dist_domain" {
    value = aws_cloudfront_distribution.alb_cf_dist.domain_name
}

output "cf_name" {
    value = aws_cloudfront_distribution.alb_cf_dist.domain_name
}

output "cf_zone_id" {
    value = aws_cloudfront_distribution.alb_cf_dist.hosted_zone_id
}