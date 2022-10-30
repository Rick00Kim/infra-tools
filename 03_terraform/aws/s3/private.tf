resource "aws_s3_bucket" "new-s3-bucket" {
  bucket = var.target-s3-name

  tags = {
    Kind = var.tag-kind
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.new-s3-bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.new-s3-bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_versioning" "versioning_example" {
  bucket = aws_s3_bucket.new-s3-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
