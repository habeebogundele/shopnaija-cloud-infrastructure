resource "aws_s3_bucket" "this" {

  bucket = "${var.project_name}-uploads"

}

resource "aws_s3_bucket_versioning" "this" {

  bucket = aws_s3_bucket.this.id

  versioning_configuration {

    status = "Enabled"

  }

}

resource "aws_s3_bucket_lifecycle_configuration" "this" {

  bucket = aws_s3_bucket.this.id

  rule {

    id = "archive"

    status = "Enabled"

    transition {

      days = 30

      storage_class = "STANDARD_IA"

    }

  }

}

resource "aws_s3_bucket_policy" "this" {

  bucket = aws_s3_bucket.this.id

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Sid = "DenyInsecureTransport"

        Effect = "Deny"

        Principal = "*"

        Action = "s3:*"

        Resource = [

          aws_s3_bucket.this.arn,

          "${aws_s3_bucket.this.arn}/*"

        ]

        Condition = {

          Bool = {

            "aws:SecureTransport" = "false"

          }

        }

      }

    ]

  })

}

