resource "terraform_data" "public_storage" {

  provisioner "local-exec" {
    command = <<-EOT
      aws s3api create-bucket \
        --bucket public-object-storage-${random_string.bucket_suffix.result} \
        --region ${var.aws_region}

      aws s3api put-public-access-block \
        --bucket public-object-storage-${random_string.bucket_suffix.result} \
        --public-access-block-configuration "BlockPublicAcls=false,IgnorePublicAcls=false,BlockPublicPolicy=false,RestrictPublicBuckets=false"
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = "aws s3 rb s3://public-object-storage-${random_string.bucket_suffix.result} --force || true"
  }
}


resource "terraform_data" "protected_storage" {

  provisioner "local-exec" {
    command = <<-EOT
      aws s3api create-bucket \
        --bucket protected-object-storage-${random_string.bucket_suffix.result} \
        --region ${var.aws_region}

      aws s3api put-public-access-block \
        --bucket protected-object-storage-${random_string.bucket_suffix.result} \
        --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = "aws s3 rb s3://protected-object-storage-${random_string.bucket_suffix.result} --force || true"
  }
}


resource "random_string" "bucket_suffix" {
  length  = 6
  special = false
  upper   = false
}
