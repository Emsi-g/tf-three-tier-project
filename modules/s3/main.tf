# Craete s3 bucket
resource "aws_s3_bucket" "s3_bucket" {
    bucket                      = var.bucket_name
}

# Create OAC
resource "aws_s3_bucket_ownership_controls" "s3_bucket_owner" {
    bucket                      = aws_s3_bucket.s3_bucket.id
    rule {
      object_ownership          = "BucketOwnerPreferred"
    }       
}

# Configure s3 bucket acl
resource "aws_s3_bucket_acl" "s3_bucket_acl" {
    depends_on                  = [ aws_s3_bucket_ownership_controls.s3_bucket_owner ]
    bucket                      = aws_s3_bucket.s3_bucket.id
    acl                         = "private"
}

# Attach bucket policy
resource "aws_s3_bucket_policy" "s3_bucket_policy" {
    bucket                      = aws_s3_bucket.s3_bucket.id
    policy                      = data.aws_iam_policy_document.cf_oac_access.json
}

# Create "images" folder
resource "aws_s3_object" "images_folder" {
    bucket                      = aws_s3_bucket.s3_bucket.id
    key                         = "images/"
}