
# S3 static website hosting
resource "aws_s3_bucket" "test" {
  bucket_prefix = "s3-website-test"
}

resource "aws_s3_bucket_website_configuration" "website_configuration" {
  bucket = aws_s3_bucket.test.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
}

resource "aws_s3_bucket_acl" "test_backet_acl" {
  bucket = aws_s3_bucket.test.id
  acl    = "private"
}
