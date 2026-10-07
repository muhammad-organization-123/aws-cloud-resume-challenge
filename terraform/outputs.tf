

output "S3_BUCKET" {
  value = aws_s3_bucket.website_bucket.id
}
output "CLOUDFRONT_DISTRIBUTION_ID" {
  value = aws_cloudfront_distribution.website.id
}

output "api_url" {
  value = "${aws_apigatewayv2_api.http_api.api_endpoint}/visitors"
}