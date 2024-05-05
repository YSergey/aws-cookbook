resource "aws_cloudfront_origin_access_control" "s3_access" {
    name                              = "${var.sysname}-${var.env}-OAC"
    origin_access_control_origin_type = "s3"
    signing_behavior                  = "always"
    signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "main" {
    enabled = true
    is_ipv6_enabled = true
    default_root_object = "index.html"

    origin {
        origin_id                = var.bucket_id
        domain_name              = var.bucket_regional_domain_name
        origin_access_control_id = aws_cloudfront_origin_access_control.s3_access.id
    }

    viewer_certificate {
        cloudfront_default_certificate = true
    }

    default_cache_behavior {
        min_ttl                = 0
        default_ttl            = 0
        max_ttl                = 0
        viewer_protocol_policy = "redirect-to-https"
        
        cached_methods         = ["GET", "HEAD"]
        allowed_methods        = ["GET", "HEAD"]
        target_origin_id       = var.bucket_id

        forwarded_values {
            query_string = false
            headers      = []
            cookies {
                forward = "none"
            }
        }
    }

    restrictions {
        geo_restriction {
            restriction_type = "none"
        }
    }
}
