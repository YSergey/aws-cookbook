# Querying Files on S3 Using Amazon Ahena

## Problem

You need to run a SQL query on CSV files stored on object storage without indexing them.

## Solution

Configure an Amazon Athena results S3 bucket location, create a Data Catalog data-base and table in the Athena Editor, and run a SQL query on the data in the S3 bucket.

## Step

## Preparation

- Amazon S3

### Step1

Log in to the AWS Console and go to the Athena console.

### Step2

In the query Editor, click the Setting tab and confugure a Query result location using the S3 bucket that you created and prefix  S3://bucket/folder/object/. Click Manage, select the bucket, and click Choose. As an option, you can encrypt the results.

### Step3

Back in the Editor tab, run the following SQL statement to create a Data Catalog database.

```sql
CREATE DATABASE `awscookbook704db1`
```

### Step4

Run a new statement in the Query Editor to create a table within the database that references the S3 bucket location of the data and the schema of the data. Be sure to replace BUCKET_NAME.

```sql
CREATE EXTERNAL TABLE IF NOT EXISTS default. `awscookbook704table` (
    `title` string,
    `other titles` string,
    `bl record id` bigint,
    `type of resource` string,
    `content type` string,
    `material type` string,
    `bnb number` string,
    `isbn` string,
    `name` string,
    `dates associated with name` string,
    `type of name` string,
    `role` string,
    `all names` string,
    `series title` string,
    `number within series` string,
    `country of publication` string,
    `place of publication` string,
    `publisher` string,
    `date of publication` string,
    `edition` string,
    `physical description` string,
    `dewey classification` string,
    `bl shelfmark` string,
    `topics` string,
    `genre` string,
    `languages` string,
    `notes` string
)
ROW FORMAT SERGE 'org.apache.hive.serde2.lazy.LazySimpleSerde'
WITH SERDEPROPFILERS (
    'serialization.format' = ',',
    'field.delim' = ',',
) LOCATION 's3://BUCKET_NAME/data'
TBL_PROPERTIES ('has_encrypted_data' = 'false');
```


## Challenge

Configure Ahena to use the Glue Data Catalog with a Glue crawler for a source dataset on S3 that you do not have a predefined schema for.