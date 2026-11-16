resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "terraform_data" "ctfd_uploads" {
  input = "ctfd-uploads-${random_string.bucket_suffix.result}"

  provisioner "local-exec" {
    command = <<-EOT
      aws s3api create-bucket \
        --bucket ${self.input} \
        --region ${var.aws_region}

      aws s3api put-public-access-block \
        --bucket ${self.input} \
        --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"

      aws s3api put-bucket-tagging \
        --bucket ${self.input} \
        --tagging 'TagSet=[{Key=Name,Value=ctfd_uploads}]'
    EOT
  }

  provisioner "local-exec" {
    when    = destroy
    command = "aws s3 rb s3://${self.input} --force"
  }
}