import logging
import uuid
import boto3


def success(msg):
    return {
        'statusCode': 200,
        'body': msg
    }


def lambda_handler(event, context):
    # from s3 trigger

    print(event)
    print(context)

    records = event.get("Records")

    for record in records:
        try:
            source_bucket = record["s3"]["bucket"]["name"]
            source_object = record["s3"]["object"]["key"]

            id = context.aws_request_id

            s3_path = f"s3://{source_bucket}/{source_object}"
            # job_name = f"{source_object}-{str(uuid.uuid4())}"
            # job_name = f"{source_object.replace('/','-')}-{id}"
            job_name = f"voice-to-text-{id}"

            print(f'>> transcribe job name: {job_name}')

            client = boto3.client('transcribe')

            result = client.start_transcription_job(
                TranscriptionJobName=job_name,
                LanguageCode='en-US',
                MediaFormat='mp3',
                Media={
                    'MediaFileUri': s3_path
                },
                OutputBucketName="poc-chosen-callcenter-output"
            )

            return {
                'TranscriptionJobName': result['TranscriptionJob']['TranscriptionJobName']
            }
        except Exception as e:
            print(e)
            logging.error(e)
