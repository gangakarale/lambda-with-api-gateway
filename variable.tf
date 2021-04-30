variable "aws_profile" {
  type        = string
  default     = "default"
  description = "Name of configured AWS profile to use"
}

variable "aws_region" {
  type        = string
  default     = "eu-west-1"
  description = "Region where to provision Lambda"
}

variable "lambda_iam_name" {
  type        = string
  default     = "lambda-iam-role"
  description = "Name of IAM for Lambda"
}

variable "lambda_name" {
  type        = string
  default     = "test-lambda-with-api-gateway"
  description = "Lambda function name"
}

variable "lambda_handler" {
  type = string
  description = "Function entrypoint in your code"
}

variable "lambda_runtime" {
  default = "python3.7"
  type = string
  description = "Identifier of the function's runtime."
}

variable "api_resource_path" {
  type        = string
  default     = "lambda_resource"
  description = "The last path segment of this API resource"
}

variable "api_http_method" {
  type        = string
  default     = "GET"
  description = "The HTTP Method (GET, POST, PUT, DELETE, HEAD, OPTIONS, ANY)"
}

variable "stage_name" {
  type        = string
  default     = "test"
  description = "Name of the stage to create with this deployment. If the specified stage already exists, it will be updated to point to the new deployment"
}