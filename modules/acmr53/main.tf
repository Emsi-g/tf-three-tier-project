terraform {
  required_providers {
    aws = {
        source                        = "hashicorp/aws"
        configuration_aliases         = [ aws.acm, aws.route53_acc ]
    }
  }
}

# Create cert in US for CF
resource "aws_acm_certificate" "cf_cert" {
    provider                          = aws.acm
    domain_name                       = var.uri_name
    validation_method                 = "DNS"

    lifecycle {
      create_before_destroy = true
    }
}

# Create cert in SG for ALB
resource "aws_acm_certificate" "alb_cert" {
    domain_name                       = var.uri_name
    validation_method                 = "DNS"

    lifecycle {
      create_before_destroy           = true
    }
}

# Get hosted zone details
data "aws_route53_zone" "hosted_zone" {
  provider                            = aws.route53_acc
  name                                = var.domain_name
}

# Create a record set in route 53
resource "aws_route53_record" "site_domain" {
  provider                            = aws.route53_acc
  zone_id                             = data.aws_route53_zone.hosted_zone.zone_id
  name                                = tolist(aws_acm_certificate.alb_cert.domain_validation_options)[0].resource_record_name
  records                             = [tolist(aws_acm_certificate.alb_cert.domain_validation_options)[0].resource_record_value]
  type                                = tolist(aws_acm_certificate.alb_cert.domain_validation_options)[0].resource_record_type
  ttl                                 = 60
}

# ACM validation
resource "aws_acm_certificate_validation" "cert_validate" {
  certificate_arn                     = aws_acm_certificate.alb_cert.arn
  validation_record_fqdns             = [aws_route53_record.site_domain.fqdn]
}

# Create record
resource "aws_route53_record" "main_site_domain" {
    provider                          = aws.route53_acc
    zone_id                           = data.aws_route53_zone.hosted_zone.id
    name                              = var.uri_name
    type                              = "A"
    alias {
        name                          = var.cf_name
        zone_id                       = var.cf_zone_id
        evaluate_target_health        = false
    }
}