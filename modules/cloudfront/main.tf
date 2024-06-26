# S3 OAC
resource "aws_cloudfront_origin_access_control" "cf_s3_oac" {
    name                                    = "CloudFront S3 OAC"
    description                             = "Cloud Front S3 OAC"
    origin_access_control_origin_type       = "s3"
    signing_behavior                        = "always"
    signing_protocol                        = "sigv4"
}

# Creating Cloudfront Distribution for ALB
resource "aws_cloudfront_distribution" "alb_cf_dist" {
    enabled                                 = true
    aliases                                 = [ var.uri_name ]
    price_class                             = "PriceClass_200"
    # ALB Origin
    origin {
        domain_name = var.alb_dns
        origin_id = var.alb_dns
        custom_origin_config {
            http_port                       = 80
            https_port                      = 443
            origin_protocol_policy          = "https-only"
            origin_ssl_protocols            = ["TLSv1.2"]
        }
    }
    # S3 Origin
    origin {
      domain_name                           = var.s3_bucket_regional_dn
      origin_access_control_id              = aws_cloudfront_origin_access_control.cf_s3_oac.id
      origin_id                             = var.s3_bucket_regional_dn
    }
    
    # ALB Cache Behavior
    default_cache_behavior {
        allowed_methods                     = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]
        cached_methods                      = ["GET", "HEAD", "OPTIONS"]
        target_origin_id                    = var.alb_dns
        compress                            = true
        viewer_protocol_policy              = "redirect-to-https"
        forwarded_values {
            headers                         = ["*"]
            query_string                    = false
            cookies {
                forward                     = "none"
            }
        }
    }

    # S3 Cache Behavior
    ordered_cache_behavior {
        path_pattern                        = "/images/*"
        allowed_methods                     = ["GET", "HEAD", "OPTIONS"]
        cached_methods                      = ["GET", "HEAD"]
        target_origin_id                    = var.s3_bucket_regional_dn
        compress                            = true
        viewer_protocol_policy              = "redirect-to-https"
        cache_policy_id                     = "658327ea-f89d-4fab-a63d-7e88639e58f6" 
    }
    
    restrictions {
        geo_restriction {
          restriction_type                  = "blacklist"
            locations                       = ["CN", "RU", "KP"]
        }   
    }
    viewer_certificate {
        acm_certificate_arn                 = var.cf_cert_arn
        ssl_support_method                  = "sni-only" 
        minimum_protocol_version            = "TLSv1.2_2021"
    }
    tags = {
      Name                                  = "${var.project_name}-cf-distribution"
    }
}


