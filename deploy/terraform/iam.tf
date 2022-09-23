data "aws_iam_policy_document" "aws_lambda_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}


resource "aws_iam_role" "lambda_exec" {
  name = "${local.owner_id}-lambda-iam-role-${local.suffix}"

  assume_role_policy = data.aws_iam_policy_document.aws_lambda_trust_policy.json

  tags = local.tags
}


resource "aws_iam_role_policy_attachment" "lambda_exec_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


resource "aws_iam_role_policy_attachment" "lambda_bucket_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_source_bucket.arn
}


resource "aws_iam_policy" "lambda_source_bucket" {
  name = "${local.owner_id}-lambda-source-bucket-policy-${local.suffix}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:*Object"
          # "s3:PutObject",
          # "s3:GetObject",
          # "s3:ListBucket",
        ]
        Resource = [
          "${aws_s3_bucket.lambda_source.arn}",
          "${aws_s3_bucket.audio_input.arn}",
          "${aws_s3_bucket.transcription_output.arn}",
        ]
      }
    ]
  })

  tags = local.tags
}


resource "aws_iam_role_policy_attachment" "transcribe_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonTranscribeFullAccess"
}

resource "aws_iam_role_policy_attachment" "s3_fullaccess_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}
