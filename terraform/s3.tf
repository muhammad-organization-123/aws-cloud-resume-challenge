resource "aws_s3_bucket" "website_bucket" {
  bucket = var.bucket_name

  force_destroy = true

  tags = merge(var.tags, {
    Name = "website"
  })
}



resource "aws_s3_bucket_policy" "website_oac_policy" {
  bucket = aws_s3_bucket.website_bucket.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "AllowCloudFrontAccess"
      Effect = "Allow"
      Principal = {
        Service = "cloudfront.amazonaws.com"
      }
      Action   = "s3:GetObject"
      Resource = "${aws_s3_bucket.website_bucket.arn}/*"
      Condition = {
        StringEquals = {
          "AWS:SourceArn" = aws_cloudfront_distribution.website.arn
        }
      }
    }]
  })
}





###objects
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "index.html"
  content      = templatefile("assets/index.html", { api_url = "${aws_apigatewayv2_api.http_api.api_endpoint}/visitors" })
  content_type = "text/html"
  etag         = md5(templatefile("assets/index.html", { api_url = "${aws_apigatewayv2_api.http_api.api_endpoint}/visitors" }))
}

resource "aws_s3_object" "skills" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "skills.html"
  content      = templatefile("assets/skills.html", { api_url = "${aws_apigatewayv2_api.http_api.api_endpoint}/visitors" })
  content_type = "text/html"
  etag         = md5(templatefile("assets/skills.html", { api_url = "${aws_apigatewayv2_api.http_api.api_endpoint}/visitors" }))
}

resource "aws_s3_object" "contact" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "contact.html"
  content      = templatefile("assets/contact.html", { api_url = "${aws_apigatewayv2_api.http_api.api_endpoint}/visitors" })
  content_type = "text/html"
  etag         = md5(templatefile("assets/contact.html", { api_url = "${aws_apigatewayv2_api.http_api.api_endpoint}/visitors" }))
}


resource "aws_s3_object" "custom_error_response" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "error.html"
  source       = "assets/error.html" # path to your local file
  content_type = "text/html"
  etag         = filemd5("assets/error.html")
}

resource "aws_s3_object" "image" {
  bucket       = aws_s3_bucket.website_bucket.id
  key          = "image.png"
  source       = "assets/image.png"
  content_type = "image/png"
  etag         = filemd5("assets/image.png")
}


resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website_bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "versioning_website" {
  bucket = aws_s3_bucket.website_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}