
provider "aws" {
  profile = var.aws_profile
  region = var.aws_region
}

# Create zip to deploy (Lambda Package)
data "archive_file" "lambda_zip" {
  source_file = "${path.root}/lambda/hello_world.py"
  output_path = "${path.root}/lambda.zip"
  type = "zip"
}

# IAM role for lambda
resource "aws_iam_role" "lambda_iam" {
  name = var.lambda_iam_name

  assume_role_policy = file("${path.module}/policy.json")
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_iam.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Lambda Function
resource "aws_lambda_function" "lambda" {
  function_name = var.lambda_name
  handler = var.lambda_handler
  role = aws_iam_role.lambda_iam.arn
  runtime = var.lambda_runtime
  filename = "lambda.zip"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
}

# Create API Gateway
resource "aws_api_gateway_rest_api" "lambda_api" {
  name = var.lambda_name
}

resource "aws_api_gateway_resource" "lambda_api_resource" {
  parent_id = aws_api_gateway_rest_api.lambda_api.root_resource_id
  path_part = var.api_resource_path
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
}

resource "aws_api_gateway_method" "method" {
  authorization = "NONE"
  http_method = var.api_http_method
  resource_id = aws_api_gateway_resource.lambda_api_resource.id
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
}

resource "aws_api_gateway_integration" "integration" {
  http_method = var.api_http_method
  resource_id = aws_api_gateway_resource.lambda_api_resource.id
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  integration_http_method = "POST"
  type = "AWS_PROXY"
  uri = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${aws_lambda_function.lambda.arn}/invocations"
}

resource "aws_api_gateway_deployment" "deployment" {
  depends_on = [aws_api_gateway_integration.integration]
  rest_api_id = aws_api_gateway_rest_api.lambda_api.id
  stage_name = var.stage_name
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.lambda_api.execution_arn}/*/*"
}