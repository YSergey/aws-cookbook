resource "aws_signer_signing_profile" "my_signing_profile" {
  name = "simpleprofile12345"
  platform_id = "AWSLambda-SHA384-ECDSA"  # Use the appropriate platform ID

  lifecycle {
    prevent_destroy = false
  }
}

resource "aws_lambda_code_signing_config" "lambda_code_signing_config" {
  allowed_publishers {
    signing_profile_version_arns = [aws_signer_signing_profile.my_signing_profile.version_arn]
  }

  policies {
    untrusted_artifact_on_deployment = "Warn"
  }
}

# Assume you have uploaded your source code to the S3 bucket "source_code" and noted the version ID
# Replace "source_version" with the actual version of the object in S3
resource "aws_signer_signing_job" "my_signing_job" {

  source {
    s3 {
      bucket = var.source_code_bucket
      key         = var.path_key
      version     = var.source_version_id
    }
  }

  destination {
    s3 {
      bucket = var.signed_code_bucket
      prefix = "signed/${var.object_key}-signed"
    }
  }

  profile_name = aws_signer_signing_profile.my_signing_profile.name
}
