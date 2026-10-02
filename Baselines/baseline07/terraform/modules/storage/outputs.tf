output "public_storage_name" {
  value = aws_s3_bucket.public_storage.id
}

output "protected_storage_name" {
  value = aws_s3_bucket.protected_storage.id
}