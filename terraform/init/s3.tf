resource "aws_s3_bucket" "terraform" {
  bucket   = var.s3_bucket_name
  provider = aws.default

  tags = merge(tomap({
    name = var.s3_bucket_name,
    type = "storage" }),
    local.infra_tags,
  )

}

resource "aws_s3_bucket_versioning" "terraform" {
  bucket   = aws_s3_bucket.terraform.id
  provider = aws.default
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform" {
  bucket   = aws_s3_bucket.terraform.id
  provider = aws.default
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
