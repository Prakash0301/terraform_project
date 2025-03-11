# Create S3 bucket
resource "aws_s3_bucket" "my_tf_test_bucket" {
  bucket = var.bucket_name
}

# Set ownership controls
resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.my_tf_test_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Disable public access restrictions
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.my_tf_test_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Use a bucket policy instead of ACLs
resource "aws_s3_bucket_policy" "public_policy" {
  bucket = aws_s3_bucket.my_tf_test_bucket.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = "*",
        Action    = "s3:GetObject",
        Resource  = "${aws_s3_bucket.my_tf_test_bucket.arn}/*"
      }
    ]
  })
}

# Upload index.html
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.my_tf_test_bucket.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
}

# Upload error.html
resource "aws_s3_object" "error" {
  bucket       = aws_s3_bucket.my_tf_test_bucket.id
  key          = "error.html"
  source       = "error.html"
  content_type = "text/html"
}

# Upload profile.png
resource "aws_s3_object" "profile" {
  bucket       = aws_s3_bucket.my_tf_test_bucket.id
  key          = "profile.png"
  source       = "profile.png"
  content_type = "image/png"
}

# Enable website hosting
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.my_tf_test_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
