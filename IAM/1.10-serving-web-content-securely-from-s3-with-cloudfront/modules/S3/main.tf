resource "aws_s3_bucket" "bucket" {
    bucket = "${var.sysname}-${var.env}-bucket"

    force_destroy = false 

    tags = {
        Name = "${var.sysname}-${var.env}-bucket"
    }
}

resource "aws_s3_bucket_public_access_block" "bucket_pab" {
    bucket = aws_s3_bucket.bucket.id
    block_public_acls = true
    block_public_policy = true
    ignore_public_acls = true
    restrict_public_buckets = true
}

data "aws_iam_policy_document" "s3_main_policy" {
  statement {
    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.bucket.arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [var.cloudfront_distribution_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "allow_from_cloudfront" {
    bucket = aws_s3_bucket.bucket.id 
    policy = data.aws_iam_policy_document.s3_main_policy.json
}

# resource "aws_s3_bucket_policy" "allow_from_cloudfront" {
#     bucket = aws_s3_bucket.bucket.id 
#     policy = jsonencode({
#         Version = "2012-10-17",
#         Statement =  [
#             {
#                 Effect = "Allow",
#                 Principal = {
#                     type = "Service",
#                     identifiers = ["cloudfront.amazonaws.com"]
#                 },
#                 Action = "s3:GetObject",
#                 Resource = ["${aws_s3_bucket.bucket.arn}/*"],
#                 Condition = {
#                     StringEquals = {
#                         "aws:SourceArn" = "${var.cloudfront_distribution_arn}"
#                     }
#                 } 
#             }
#         ]
#     })
# }

resource "aws_s3_object" "object" {
    count  = var.bucket_source_path != null && var.bucket_object_key != null ? 1 : 0
    bucket = aws_s3_bucket.bucket.id
    key    = var.bucket_object_key
    source = var.bucket_source_path
}