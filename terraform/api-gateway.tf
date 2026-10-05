resource "aws_apigatewayv2_api" "http_api" {
  name          = "muhammad-cloud-resume-http-api"
  protocol_type = "HTTP"

  cors_configuration {
    allow_origins = ["https://${var.domain_name}"]
    allow_methods = ["GET"]
    allow_headers = []
    max_age       = 300
  }

}

//connection between the API and Lambda function
resource "aws_apigatewayv2_integration" "lambda" {
  api_id = aws_apigatewayv2_api.http_api.id

  integration_type   = "AWS_PROXY"
  integration_uri    = aws_lambda_function.visitor_counter.invoke_arn
  integration_method = "POST"

  payload_format_version = "2.0"
}



resource "aws_apigatewayv2_route" "visitor_counter" {
  api_id = aws_apigatewayv2_api.http_api.id

  route_key = "GET /visitors"
  target    = "integrations/${aws_apigatewayv2_integration.lambda.id}"
}
resource "aws_apigatewayv2_stage" "default" {
  api_id = aws_apigatewayv2_api.http_api.id
  name   = "$default"

  auto_deploy = true
}




resource "aws_lambda_permission" "api_gateway" {
  statement_id  = "AllowApiGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.visitor_counter.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_apigatewayv2_api.http_api.execution_arn}/*/*"
}