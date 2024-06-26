terraform {
    backend "s3" {
        bucket              = "your-s3-bucket"                  # Should be existing s3 bucket
        key                 = "terraform-three-tier.tfstate"    # Statefile of terraform
        region              = "ap-southeast-1"                  # Region
        # dynamodb_table    = "terraform-dynamodb"              # Optional, if you want to lock your Terraform
    }
}