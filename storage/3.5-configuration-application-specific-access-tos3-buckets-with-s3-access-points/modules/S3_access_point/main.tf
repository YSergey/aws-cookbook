
resource "aws_s3_access_point" "s3_access_point" {
  bucket = var.bucket_name
  name   = var.sysname
  

  vpc_configuration {
    vpc_id = var.vpc_id
  }
}

resource "aws_s3control_access_point_policy" "access_point_A_policy" {
  access_point_arn = aws_s3_access_point.s3_access_point.arn
  policy = jsonencode({
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Principal": {
                        "AWS": "${var.aws_iam_role_arn}"
                    },
                    "Action": [
                        "s3:GetObject",
                        "s3:PutObject",
                    ],
                    "Resource":[
                        "${aws_s3_access_point.s3_access_point.arn}/object/*"
                    ] 
                }
            ]
        })
}

resource "aws_s3control_access_point_policy" "access_point_B_policy" {
  access_point_arn = aws_s3_access_point.s3_access_point.arn
  policy = jsonencode({
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Principal": {
                        "AWS": "${var.aws_iam_role_arn}"
                    },
                    "Action": [
                        "s3:GetObject"
                    ],
                    "Resource":[
                        "${aws_s3_access_point.s3_access_point.arn}/object/*"
                    ] 
                }
            ]
        })
}

