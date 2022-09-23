import logging
import os
import boto3


def success(msg):
    return {
        'statusCode': 200,
        'body': msg
    }


def lambda_handler(event, context):
    # from s3 trigger

    output_bucket = os.environ.get('TRANSCRIPTION_OUTPUT_BUCKET')
    transcription_job_name = os.environ.get('TRANSCRIPTION_JOB_NAME')

    print(event)
    print(context)

    records = event.get("Records")

    for record in records:
        try:
            source_bucket = record["s3"]["bucket"]["name"]
            source_object = record["s3"]["object"]["key"]

            _, extention = os.path.splitext(source_object)

            if extention not in ['.mp3', '.mp4', '.wav', '.flac']:
                raise Exception('Invalid file type, the only supported AWS Transcribe file types are mp3, mp4, wav, flac')

            output_id = context.aws_request_id[:8]

            s3_path = f"s3://{source_bucket}/{source_object}"
            # s3_path = f"https://{source_bucket}.ap-northeast-2.amazonaws.com/{source_object}"
            # job_name = f"aws-connect-audio-to-text-{id}"

            # print(f'>> transcribe job name: {job_name}')

            client = boto3.client('transcribe')

            result = client.start_transcription_job(
                TranscriptionJobName=f"{transcription_job_name}-{output_id}",
                LanguageCode='en-US',
                MediaFormat='mp3',
                Media={
                    'MediaFileUri': s3_path
                },
                OutputBucketName=output_bucket
            )

            return {
                'TranscriptionJobName': result['TranscriptionJob']['TranscriptionJobName']
            }
        except Exception as e:
            print(e)
            logging.error(e)
