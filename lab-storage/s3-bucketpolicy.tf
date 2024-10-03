# TODO: For each resource below, add the correct values.

 resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
   bucket = aws_s3_bucket.portfolio_bucket.id
   rule {
     object_ownership = "BucketOwnerPreferred"
   }
 }

 resource "aws_s3_bucket_public_access_block" "example" {
   bucket = aws_s3_bucket.portfolio_bucket.id
   block_public_acls       = false
   block_public_policy     = false
   ignore_public_acls      = false
   restrict_public_buckets = false
 }

 resource "aws_s3_bucket_policy" "bucket-policy" {
   bucket = aws_s3_bucket.portfolio_bucket.id # bucket to attach to
   policy = data.aws_iam_policy_document.iam-policy-1.json # policy to attach
 }
 data "aws_iam_policy_document" "iam-policy-1" {
   statement {
     sid    = "allow read"
     effect = "Allow"
     resources = ["${aws_s3_bucket.portfolio_bucket.arn}/*"]# acesss to the bucket arn and all contents within the bucket arn
     actions = ["s3:GetObject"]
     principals {
       type        = "*" # Anyone should be able to access
       identifiers =  ["*"] # Should be a list of everything
     }
   }
 }
