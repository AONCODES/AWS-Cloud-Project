resource "aws_s3_bucket" "public_storage" {
  bucket_prefix = "public-object-storage-"
  

  tags = {
    Name = "public-object-storage"
    Task = "Object Storage"
  }
}

resource "aws_s3_bucket_public_access_block" "public_storage" {
  bucket = aws_s3_bucket.public_storage.id

  block_public_acls       = false
  ignore_public_acls      = false
  block_public_policy     = false
  restrict_public_buckets = false
}


resource "aws_s3_bucket" "protected_storage" {
  bucket_prefix = "protected-object-storage-"
  

  tags = {
    Name = "protected-object-storage"
    Task = "Object Storage"
  }
}

resource "aws_s3_bucket_public_access_block" "protected_storage" {
  bucket = aws_s3_bucket.protected_storage.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}