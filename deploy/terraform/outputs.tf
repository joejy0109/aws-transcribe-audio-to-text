output "audio_input_bucket_arn" {
  value = aws_s3_bucket.audio_input.arn
}

output "transcription_output_bucket_arn" {
  value = aws_s3_bucket.transcription_output.arn
}


output "audio_input_bucket_name" {
  value = aws_s3_bucket.audio_input.bucket
}


output "transcription_output_bucket_name" {
  value = aws_s3_bucket.transcription_output.bucket
}

output "lambda_source_bucket_name" {
  value = aws_s3_bucket.lambda_source.bucket
}
