resource "aws_s3_bucket_versioning" "example" {
  bucket =  aws_s3_bucket.portfolio_bucket.id # Use your existing bucket name

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_object_lock_configuration" "example" {
  bucket = "portfolio-bucket-junie"  # Use your existing bucket name

  rule {
    default_retention {
      mode = "COMPLIANCE"
      days = 5
    }
  }
}

output "bucket_id" {
  value = "portfolio-bucket-junie"
}
