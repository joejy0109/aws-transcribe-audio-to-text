output "audio_input_bucket_arn" {
  value = aws_s3_bucket.audio_input.arn
}

output "transcription_output_bucket_arn" {
  value = aws_s3_bucket.transcription_output.arn
}
