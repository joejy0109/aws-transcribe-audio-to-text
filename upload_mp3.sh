#!/bin/bash


# BUCKET='poc-chosen-callcenter'
BUCKET='jeongyong-audio-input-5yinxigd'

# aws s3 cp sample_voice_eng.mp3 s3://poc-chosen-callcenter/connect/${ID}/CallRecordings/$(date "+%Y-%m-%d-%H-%M-%S").mp3
aws s3 cp sample_voice_eng.mp3 s3://${BUCKET}/connect/jeongyong/CallRecordings/$(date "+%Y-%m-%d-%H-%M-%S").mp3