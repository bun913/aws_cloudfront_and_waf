resource "aws_s3_bucket" "static" {
  bucket = "${var.prefix}-static"
}

resource "aws_s3_bucket_versioning" "static" {
  bucket = aws_s3_bucket.static.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "static" {
  bucket = aws_s3_bucket.static.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "static" {
  bucket = aws_s3_bucket.static.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# CloudFront経由のアクセスに制限
resource "aws_s3_bucket_policy" "static" {
  bucket = aws_s3_bucket.static.id
  policy = templatefile("${path.module}/policy/bucket_policy.json", {
    OAI        = aws_cloudfront_origin_access_identity.static.iam_arn
    BUCKET_ARN = aws_s3_bucket.static.arn
  })
}

# テスト用にファイルを配置
resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.static.id
  key    = "static/test.json"
  source = "${path.module}/object/test.json"
}
