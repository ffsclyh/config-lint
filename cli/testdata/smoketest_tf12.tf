## Setup Helper
resource "aws_kms_key" "test_key" {
  enable_key_rotation = true
}

resource "aws_s3_bucket" "test_bucket" {
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.test_key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }
}

# Pass
resource "aws_alb" "access_logs_enabled_set_to_true" {
  access_logs {
    bucket  = aws_s3_bucket.test_bucket.bucket
    prefix  = "foo"
    enabled = true
  }
}
