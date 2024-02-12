import json
import boto3
import os
import csv
import codecs
import sys

s3 = boto3.client('s3') 
dynamodb = boto3.resource('dynamodb')

bucket = os.environ['bucket']
key = 'sample_data.csv'
tableName = 'automating-csv-import-into-dynamodb-table'

# def lambda_handler(event, context):

#    try:
#        obj = s3.Object(bucket, key).get()['Body']
#    except:
#        print("Error: S3 error")

#    batch_size = 100
#    batch = []

#    for row in csv.DictReader(codecs.getreader('utf-8')(obj)):
#       if len(batch) >= batch_size:
#          write_table(batch)
#          batch.clear()

#       batch.append(row)

#    if batch:
#       write_table(batch)

#    return {
#       'statusCode': 200,
#       'body': json.dumps('Success: Import complete')
#    }

# def write_table(rows):
#    try:
#       table = dynamodb.Table(tableName)
#    except:
#       print("Error: Table error")

#    try:
#       with table.batch_writer() as batch:
#          for i in range(len(rows)):
#             batch.put_item(
#                Item=rows[i]
#             )
#    except:
#       print("Error: Import failed")

def lambda_handler(event, context):
    # Environment variables
    bucket = os.environ['bucket']
    key = 'sample_data.csv'  # Adjust if you need to read the key dynamically from the event
    table_name = os.environ.get('tableName', 'automating-csv-import-into-dynamodb-table')

    # Ensure that the bucket and table name are set
    if not bucket or not table_name:
        print("Error: Bucket or Table name environment variables not set correctly.")
        return {
            'statusCode': 500,
            'body': json.dumps('Error: Environment variables not set')
        }

    # Fetching the file from S3
    try:
        response = s3.get_object(Bucket=bucket, Key=key)
    except Exception as e:
        print(f"Error getting object {key} from bucket {bucket}. Make sure they exist and your bucket is in the same region as this function.")
        print(e)
        return {
            'statusCode': 500,
            'body': json.dumps('Error: Could not access S3 object')
        }

    # Process and write data to DynamoDB
    try:
        rows = csv.DictReader(codecs.getreader('utf-8')(response['Body']))
        batch_size = 100
        batch = []

        for row in rows:
            batch.append(row)
            if len(batch) >= batch_size:
                write_table(batch, table_name)
                batch.clear()

        if batch:  # Write the last batch if it exists
            write_table(batch, table_name)

        return {
            'statusCode': 200,
            'body': json.dumps('Success: Import complete')
        }

    except Exception as e:
        print(f"Error processing the file from bucket {bucket}.")
        print(e)
        return {
            'statusCode': 500,
            'body': json.dumps('Error: Could not process file')
        }

def write_table(rows, table_name):
    try:
        table = dynamodb.Table(table_name)
        with table.batch_writer() as batch:
            for row in rows:
                batch.put_item(Item=row)
    except Exception as e:
        print(f"Error writing to table: {e}")
        raise e
