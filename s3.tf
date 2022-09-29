
# S3 static website hosting
resource "aws_s3_bucket" "test" {
  bucket_prefix = "s3-website-test"
}
# バケットポリシーにIAMポリシーをアタッチ
resource "aws_s3_bucket_policy" "test" {
  bucket = aws_s3_bucket.test.id
  policy = data.aws_iam_policy_document.static-www.json
}
# s3を静的ホスティングとして使う設定
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

# バケットへのアクセスを記述したIAMポリシー
data "aws_iam_policy_document" "static-www" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.test.arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [aws_cloudfront_distribution.static-www.arn]
    }
  }
}
