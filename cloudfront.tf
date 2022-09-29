resource "aws_cloudfront_distribution" "static-www" {
  origin {
    domain_name              = aws_s3_bucket.test.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.test.id
    origin_access_control_id = aws_cloudfront_origin_access_control.test.id
  }

  enabled = true
  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = aws_s3_bucket.test.id
    viewer_protocol_policy = "allow-all"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["JP"]
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

# Origin Access Controlを作成
resource "aws_cloudfront_origin_access_control" "test" {
  name                              = "${var.prefix}-cf-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}


