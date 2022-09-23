variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = "ap-northeast-2"
}

variable "owner_id" {
  description = "The id of owner for identifying resources"
  type        = string
  default     = "jeongyong"
}

variable "lambda_source_bucket" {
  type    = string
  default = "lambda-source"
}


variable "lambda_runtime" {
  type    = string
  default = "python3.9"
}


variable "lambda_function_name" {
  type    = string
  default = "audio-transcription"
}

variable "lambda_handler_name" {
  type    = string
  default = "lambda_handler"
}

variable "lambda_source_file" {
  description = "the source file for the lambda handler"
  type        = string
  default     = "transcribe_lambda.py"
}

variable "audio_input_bucket" {
  description = "A bucket where audio source contents is stored."
  type        = string
  default     = "audio-input"
}

variable "transcription_output_bucket" {
  description = "A bucket to store results of the transcription."
  type        = string
  default     = "transcription-output"
}

variable "transcription_job_name" {
  description = ""
  type        = string
  default     = "audio-to-text"
}
