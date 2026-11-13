# S3 bucket for shared CTFd file uploads.
resource "aws_s3_bucket" "ctfd_uploads" {
  bucket_prefix = "ctfd-uploads-"

  tags = {
    Name = "ctfd_uploads"
  }
}

# Block all public access to the bucket.
resource "aws_s3_bucket_public_access_block" "ctfd_uploads" {
  bucket = aws_s3_bucket.ctfd_uploads.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}
