resource "aws_iam_role" "lambda_execution_role" {
  name = "lambda_execution_role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_execution_policy" {
  name        = "lambda_execution_policy"
  description = "Policy for Lambda execution role"
  
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"],
        Effect   = "Allow",
        Resource = "arn:aws:logs:*:*:*",
      },
      {
        Action   = ["s3:GetObject", "s3:PutObject"],
        Effect   = "Allow",
        Resource = [
          "arn:aws:s3:::docconversion/*",  
        ],
      },
      {
        Action   = "lambda:InvokeFunction",
        Effect   = "Allow",
        Resource = "*",
      },
      {
        Action   = "s3:*",
        Effect   = "Allow",
        Resource = "*",
      },
    ],
  })
}

resource "aws_iam_role_policy_attachment" "attachment_for_role_policy" {
  role = aws_iam_role.lambda_execution_role.name
  policy_arn = aws_iam_policy.lambda_execution_policy.arn
  
}


resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.func.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.bucket.arn
}

resource "aws_lambda_function" "func" {
  filename = "${path.module}/python/deployment_package.zip"
  function_name = "doccon"
  role = aws_iam_role.lambda_execution_role.arn
  handler = "lambda_function.lambda_handler"
  runtime = "python3.11"
  timeout = 60
  depends_on = [aws_iam_role_policy_attachment.attachment_for_role_policy]

  
}
resource "aws_s3_bucket" "bucket" {
  bucket = "docconversion"
}


resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.func.arn
    events              = ["s3:ObjectCreated:*"]
    
  }

  depends_on = [aws_lambda_permission.allow_bucket]
  
}

resource "aws_s3_object" "object" {
  bucket = "docconversion"
  key    = "ELLLO.docx"
  source = "C:\\Users\\nawas\\Desktop\\ELLLO.docx"

  
  etag = filemd5("C:\\Users\\nawas\\Desktop\\ELLLO.docx")

  depends_on = [aws_s3_bucket.bucket, aws_lambda_function.func]
}