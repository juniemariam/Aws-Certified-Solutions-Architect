terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "us-west-1"
}

locals {
  s3_template_filepath = "./s3-template"
  content_type_map = {
    # Web files
    "html"  = "text/html"
    "htm"   = "text/html"
    "css"   = "text/css"
    "scss"  = "text/x-scss"
    "js"    = "application/javascript"
    "json"  = "application/json"
    "xml"   = "application/xml"
    "txt"   = "text/plain"

    # Images
    "jpg"   = "image/jpeg"
    "jpeg"  = "image/jpeg"
    "png"   = "image/png"
    "gif"   = "image/gif"
    "svg"   = "image/svg+xml"
    "ico"   = "image/x-icon"
    "webp"  = "image/webp"
  }


}

# TODO: Define the values for these resources below. Look at README for links to read.

 resource "aws_s3_bucket" "portfolio_bucket" {
   bucket = "portfolio-bucket-junie"
   tags = {
     Name        = "My Portfolio Bucket"
     Environment = "Dev"
   }

 }
 resource "aws_s3_object" "template_files" {
   for_each = fileset(local.s3_template_filepath, "**")
   bucket = aws_s3_bucket.portfolio_bucket.bucket
   key    = each.value
   source = "${local.s3_template_filepath}/${each.value}"
   content_type = lookup(local.content_type_map, split(".", "${path.module}/s3-template/${each.value}")[1], null)
   #content_type = lookup(local.content_type_map, element(split(".", "${each.value}"), length(split(".", "${each.value}")) - 1), null)

   # The filemd5() function is available in Terraform 0.11.12 and later
   # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
   # etag = "${md5(file("path/to/file"))}"
   etag = filemd5("${local.s3_template_filepath}/${each.value}")

 }
