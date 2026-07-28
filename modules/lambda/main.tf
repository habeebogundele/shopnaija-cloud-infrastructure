resource "aws_iam_role" "lambda_role" {

  name = "${var.project_name}-lambda-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [{

      Action = "sts:AssumeRole"

      Effect = "Allow"

      Principal = {

        Service = "lambda.amazonaws.com"

      }

    }]

  })

}

resource "aws_iam_role_policy_attachment" "basic" {

  role = aws_iam_role.lambda_role.name

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"

}

resource "aws_lambda_function" "this" {

  function_name = "${var.project_name}-image-upload"

  filename = "${path.module}/lambda_function.zip"

  handler = "lambda_function.lambda_handler"

  runtime = "python3.12"

  role = aws_iam_role.lambda_role.arn

}

resource "aws_s3_bucket_notification" "notify" {

  bucket = var.bucket_name

  lambda_function {

    lambda_function_arn = aws_lambda_function.this.arn

    events = [

      "s3:ObjectCreated:*"

    ]

  }

}
