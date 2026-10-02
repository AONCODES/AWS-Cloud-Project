output "public_storage_name" {
  value = "public-object-storage-${random_string.bucket_suffix.result}"
}

output "protected_storage_name" {
  value = "protected-object-storage-${random_string.bucket_suffix.result}"
}