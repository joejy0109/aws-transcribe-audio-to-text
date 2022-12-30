#!/bin/bash

BUCKET_SUFFIX=$@

if [ -z $BUCKET_SUFFIX ]; then
  echo "[ERR] Required a bucket suffix string."
  exit 1
fi

aws s3 rm s3://jeongyong-audio-input-${BUCKET_SUFFIX}  --recursive
aws s3 rm s3://jeongyong-transcription-output-${BUCKET_SUFFIX}  --recursive