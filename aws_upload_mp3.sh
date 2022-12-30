#!/bin/bash

SUFFIX='j6xhbaz4'

BUCKET="jeongyong-audio-input-${SUFFIX}"

aws s3 cp sample_voice_eng.mp3 s3://${BUCKET}/connect/jeongyong/CallRecordings/$(date "+%Y-%m-%d-%H-%M-%S").mp3