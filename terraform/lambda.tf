
//trust policy 
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "cloud-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

data "aws_iam_policy_document" "lambda_dynamodb_update" {
  statement {
    sid    = "AllowUpdateVisitorCounter"
    effect = "Allow"

    actions = [
      "dynamodb:UpdateItem",
    ]

    resources = [aws_dynamodb_table.visitor_counter.arn]
  }
}

resource "aws_iam_role_policy" "lambda_dynamodb_update" {
  name   = "cloud-lambda-dynamodb-update"
  role   = aws_iam_role.lambda_role.id
  policy = data.aws_iam_policy_document.lambda_dynamodb_update.json
}

//adding AWSLambdaBasicExecutionRole for basic logging
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


data "archive_file" "lambda" {
  type        = "zip"
  source_file = "${path.module}/lambda/func.py"
  output_path = "${path.module}/lambda/func.zip"
}

# # Lambda function
resource "aws_lambda_function" "visitor_counter" {
  filename         = data.archive_file.lambda.output_path
  source_code_hash = data.archive_file.lambda.output_base64sha256

  function_name = "cloud-lambda"
  role          = aws_iam_role.lambda_role.arn
  handler       = "func.lambda_handler"

  runtime = "python3.12"

  tags = merge(var.tags, {
    Name = "muhammad-cloud-resume-challenge"
  })
}