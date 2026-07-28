resource "aws_api_gateway_rest_api" "this" {

  name = "${var.project_name}-api"

}

resource "aws_api_gateway_resource" "upload" {

  rest_api_id = aws_api_gateway_rest_api.this.id

  parent_id = aws_api_gateway_rest_api.this.root_resource_id

  path_part = "upload"

}

resource "aws_api_gateway_method" "post" {

  rest_api_id = aws_api_gateway_rest_api.this.id

  resource_id = aws_api_gateway_resource.upload.id

  http_method = "POST"

  authorization = "NONE"

}

resource "aws_api_gateway_integration" "lambda" {

  rest_api_id = aws_api_gateway_rest_api.this.id

  resource_id = aws_api_gateway_resource.upload.id

  http_method = aws_api_gateway_method.post.http_method

  integration_http_method = "POST"

  type = "AWS_PROXY"

  uri = aws_lambda_function.this.invoke_arn

}

