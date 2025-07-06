# Using a Kinesis Stream for integration of streaming data

## Problem

You need a way to ingest streaming data for your application.

## Solution

Create a Kinesis stream and verify that it is working by using thr aws cli to put a record on the stream.

## Step

### Step1

Create a Kinesis Stream

```bash
aws kinesis create-stream --stream-name AWSCookbook701 --shard-count 1
```

### Step2

Confirm that your stream in ACTIVE state

```bash
aws kinesis describe-stream-summary --stream-name AWSCookbook701 
```

## Validation Check

Put a record on the Kinesis stream:

```bash
aws kinesis put-record --stream-name AWSCookbook701 \
--partition-key 111 \
--cli-binary-format raw-in-base64-out \
--data={\"Data\":\"1\"}
```

output
```bash
{
    "ShardId": "shardId-0000000000",
    "SequenceNumber": "49233/484849"
}
```

Get the record from the Kinesis stream.
Get the shard iterator and run the get-records command

```bash
SHARD_ITERATOR=$(aws kinesis get-shard-iterator \
--shard-id shardId-0000000000
--shard-iterator-type TRIM_HORIZON \
--stream-name AWSCookbook701 \
--query 'ShardIterator' \
--output text
)

aws kinesis get-records \
--shard-iterator $SHARD_ITERATOR \
--query Records[0].Data \
--output text | base64 --decode
```

## Challenge

Automatically trigger a Lambda function to process incoming Kinesis data.