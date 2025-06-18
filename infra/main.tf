provider "aws" {
  region = "us-west-1"
}

terraform {
  backend "s3" {
    bucket         = "tarinyoom-terraform-state-bucket-663a64"
    key            = "raggle/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

resource "aws_s3_bucket" "site" {
  bucket = "tarinyoom-raggle-frontend-985a45"
}

resource "aws_s3_bucket_public_access_block" "site" {
  bucket = aws_s3_bucket.site.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.site.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.site.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "PublicReadGetObject",
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.site.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.site]
}

resource "aws_cloudfront_distribution" "cdn" {
  origin {
    domain_name = aws_s3_bucket_website_configuration.site.website_endpoint
    origin_id   = "viteS3Origin"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  aliases = ["ragdoll.tarinyoom.io"]

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "viteS3Origin"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
  }

  viewer_certificate {
    acm_certificate_arn            = aws_acm_certificate.cert.arn
    ssl_support_method             = "sni-only"
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Name = "SimpleViteCDN"
  }
}

resource "aws_acm_certificate" "cert" {
  provider          = aws.us_east_1
  domain_name       = "ragdoll.tarinyoom.io"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

output "bucket_name" {
  value = aws_s3_bucket.site.bucket
}

output "cloudfront_url" {
  value = aws_cloudfront_distribution.cdn.domain_name
}
