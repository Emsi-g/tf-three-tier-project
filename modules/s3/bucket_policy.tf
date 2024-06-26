data "aws_iam_policy_document" "cf_oac_access" {
    statement {
      principals {
        type = "Service"
        identifiers = [ "cloudfront.amazonaws.com" ]
      }
      actions = [ 
        "s3:GetObject"
       ]

      resources = [ 
        aws_s3_bucket.s3_bucket.arn,
        "${aws_s3_bucket.s3_bucket.arn}/*"
       ]
      condition {
        test = "StringEquals"
        variable = "AWS:SourceArn"
        values = [ "${var.alb_cf_dist_arn}" ]
      }
    }
}