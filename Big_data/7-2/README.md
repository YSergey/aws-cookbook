# Streaming data to Amazon S3 using Amazon Kinesi Data Firehose

## Problem

You need to deliver incoming streaming data to object storage.

## Solution

Create an S3 bucket, create a Kinesis stream, and configure Kinesis Data Firehose to deliver the stream data to the S3 bucket.

## Step

## Preparation

- Kinesis Stream
- Amazon S3

### Step1

Open the Kinesis Data Firehose console and click the Create delivery stream button; choose Amazon Kinesis Data Streams for the source and Amazon S3 for the destination.


### Step2

For Source settings, choose the Kinesis stream that you create in the preparation steps.

### Step3

Keep the defaults(Disabled) for "Transform and convert records" options.
For Destination settings, browse for and choose the S3 bucket that you created in the preparation steps, and keep the defaults for the other options(disabled partitioning and no prefixes).

### Step4

Under the Advanced settings section, confirm that the "Create or update IAM role" is selected. This will create an IAM role that Kinesis can use to access the stream and S3 bucket.

## Validation Check

You can test delivery to the stream from within the Kinesis console.
Click the Delivery stream link in the left navigation menu, choose the stream you created, expand the "Test with demo data" section, and click the :Start sending demo data" button.
This will initiate sending sample data to your stream so you can verify that it is making it to S3 bucket.



## Challenge

Confirm a Firehose delivery with transformations to remove a field from the streaming before delivery.