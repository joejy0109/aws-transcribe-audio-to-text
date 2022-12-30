# Reference the audio source bucket (example: AWS Connect recoding storage bucket)
# 음성 데이터가 저장되어 있는 버킷 참조
# data "aws_s3_bucket" "audio_source" {
#   bucket = local.audio_source_bucket
# }


# A bucket of the lambda's source code.
# 람다 소스 코드가 저장될 버킷
resource "aws_s3_bucket" "audio_input" {
  bucket = local.audio_input_bucket

  tags = local.tags
}

# Configure the acl of the lambda's source code bucket.
# 람다 소스 코드 버킷의 ACL 설정
resource "aws_s3_bucket_acl" "audio_input" {
  bucket = aws_s3_bucket.audio_input.id
  acl    = "private"
}

# Configure the access block of the lambda's source code bucket.
# 람다 소스 코드 버컷에 대한 접근 차단 설정
resource "aws_s3_bucket_public_access_block" "audio_input" {
  bucket = aws_s3_bucket.audio_input.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Configure the notification for creating object to bucket.
# s3 버킷 통지 기능 설정
resource "aws_s3_bucket_notification" "audio_input" {
  bucket = aws_s3_bucket.audio_input.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.transcribe.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "connect/jeongyong/CallRecordings/"
    # filter_suffix       = ".mp3"
  }

  depends_on = [
    aws_lambda_permission.allow_bucket
  ]
}


# A bucket of the lambda's source code.
# 람다 소스 코드가 저장될 버킷
resource "aws_s3_bucket" "lambda_source" {
  bucket = local.lambda_source_bucket

  tags = local.tags
}

# Configure the acl of the lambda's source code bucket.
# 람다 소스 코드 버킷의 ACL 설정
resource "aws_s3_bucket_acl" "lambda_source" {
  bucket = aws_s3_bucket.lambda_source.id
  acl    = "private"
}

# Configure the access block of the lambda's source code bucket.
# 람다 소스 코드 버컷에 대한 접근 차단 설정
resource "aws_s3_bucket_public_access_block" "lamda_source" {
  bucket = aws_s3_bucket.lambda_source.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# A bucket of the audio-to-bucket.
# 음성-문자 변환 데이터가 저장될 버킷
resource "aws_s3_bucket" "transcription_output" {
  bucket = local.transcription_output_bucket

  tags = local.tags
}

# Configure the acl of the audio-to-text bucket.
# 음성-문자 변환 데이터 저장 버킷의 ACL 설정.
resource "aws_s3_bucket_acl" "transcription_output" {
  bucket = aws_s3_bucket.transcription_output.id
  acl    = "private"
}

# Configure the access block of the audio-to-text bucket.
# 음성-문자 변환 데이터 저장 버킷의 접근 차단 설정.
resource "aws_s3_bucket_public_access_block" "transcription_output" {
  bucket = aws_s3_bucket.transcription_output.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


