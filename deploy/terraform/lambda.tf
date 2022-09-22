# Archive a file of the lambda source code 
# 람다 서비스 소스 코드 아카이빙
data "archive_file" "lambda_source" {
  type = "zip"

  source_file = local.lambda_source_file_path
  output_path = "${local.archive_output_path}/${local.archive_filename}"
}


# Upload the lambda's source code zip file.
# 람다 서비스 소스 코드 업로드
resource "aws_s3_object" "lambda_source" {
  bucket = aws_s3_bucket.lambda_source.id

  source = data.archive_file.lambda_source.output_path
  key    = basename(data.archive_file.lambda_source.output_path)
  etag   = filemd5(data.archive_file.lambda_source.output_path)

  tags = local.tags
}


# Create a lambda function for transcribing from audio data.
# 음성 데이터를 텍스트로 처리하는 람다 서비스 함수를 생성.
resource "aws_lambda_function" "transcribe" {

  function_name = local.lambda_function_name

  # filename  = data.archive_file.lambda_source.output_path # for local file.
  s3_bucket = aws_s3_bucket.lambda_source.id
  s3_key    = local.archive_filename

  runtime = local.lambda_runtime
  handler = local.lambda_handler_name

  source_code_hash = data.archive_file.lambda_source.output_base64sha256
  # source_code_hash = filebase64sha256("${local.archive_output_path}/${local.archive_filename}")

  role = aws_iam_role.lambda_exec.arn

  environment {
    variables = {
      TRANSCRIPTION_OUTPUT_BUCKET = local.transcription_output_bucket
      TRANSCRIBE_JOB_NAME         = local.transcribe_job_name
    }
  }

  tags = local.tags
}


resource "aws_lambda_permission" "allow_bucket" {
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.transcribe.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.audio_input.arn
  statement_id  = "AllowExecutionFromS3Bucket"
}
