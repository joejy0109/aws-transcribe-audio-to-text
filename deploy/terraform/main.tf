
locals {
  owner_id = var.owner_id                # 리소스 식별을 위한 고유 아이디, 리소스명의 Prefix에도 활용된다.
  suffix   = random_string.suffix.result # 리소스 식별을 위한 Suffix 랜덤 문자열.

  lambda_source_bucket = "${local.owner_id}-${var.lambda_source_bucket}-${local.suffix}"         # 람다 서비스의 소스 코드(zip)를 저장하는 S3 버킷.
  lambda_function_name = "${local.owner_id}-${var.lambda_function_name}-${local.suffix}"         # 람다 서비스 함수명
  lambda_runtime       = var.lambda_runtime                                                      # 람다 서비스 런타임
  lambda_source_file   = var.lambda_source_file                                                  # 람다 서비스 소스 코드 모듈(파일)명
  lambda_handler_name  = "${split(".", local.lambda_source_file)[0]}.${var.lambda_handler_name}" # 람다 서비스 코드 핸들러

  audio_input_bucket          = "${local.owner_id}-${var.audio_input_bucket}-${local.suffix}"          # 음성 소스 버킷
  transcription_output_bucket = "${local.owner_id}-${var.transcription_output_bucket}-${local.suffix}" # 음성-문자 변환 저장 버킷

  current_path = abspath(path.module)                # 테라폼 현재(루트) 디렉터리 위치
  parent_path  = abspath("${local.current_path}/..") # 루트의 부모 디렉터리 위치
  root_path    = abspath("${local.parent_path}/..")  # 프로젝트 루트 디렉터리 위치

  source_root_path    = abspath("${local.parent_path}/src")       # 소스 코드 파일 루트 디렉터리 위치
  packages_root_path  = abspath("${local.parent_path}/.packages") # 패키지 모듈 디렉터리 위치
  archive_output_path = abspath("${local.parent_path}/.output")   # 소스 코드 아카이빙 디렉터리 위치

  lambda_source_file_path = abspath("${local.root_path}/${local.lambda_source_file}") # 람다 서비스 핸들러 소스 코드 파일 위치

  archive_filename = "lambda_transcription_source.zip"

  transcribe_job_name = "${local.owner_id}-${var.transcribe_job_name}-${local.suffix}" # AWS Transcribe Job명

  tags = {
    owner = "${local.owner_id}"
    env   = "poc"
  }
}

resource "random_string" "suffix" {
  length           = 8
  lower            = true
  upper            = false
  special          = false
  override_special = "/@£$"
}
