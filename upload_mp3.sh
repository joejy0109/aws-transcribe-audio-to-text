#!/bin/bash

aws s3 cp sample_voice_eng.mp3 s3://poc-chosen-callcenter/connect/jeongyong/CallRecordings/$(date "+%Y-%m-%d-%H-%M-%S").mp3