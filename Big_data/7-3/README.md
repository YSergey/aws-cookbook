# Automatically Discovering Metadata with AWS Glue Crawlers

## Problem

You have CSV data files on object storage, and you would like to discovering the schema and metadata about
the files to use in further analysis and query operations.

## Solution

Create an AWS Glue database, follow the crawler configuration wizard to configure a crawler to scan your S3 bucket data, run the crawler, and inspect the resulting table.

## Step

## Preparation

- Amazon S3

### Step1

Log in to the AWS Console and navigate to the AWS Glue console, choose Databases the left navigation menu adn select "Add database".


### Step2

Give your database a name and click create.

### Step3

Select Tabled from the left navigation menu and choose "Add tables" -> "Add tables using a crawler"

### Step4

Follow the "Add crawler" wizard. For the crawler source type, choose "Data stores," crawl all folders, S3 as "Data store"(do not define a Connection), choose your S3 bucket and "data" folder in "Include path,"
and do not choose a sample size. Choose to create an IAM role, and suffix it with AWSCookbook703. For a frequency, choose "Run on demand" and select the database you created in step2.
Confirm the configuration on the "Review all steps" page and click Finish.

### Step5

From the left navigation menu, select Crawlers. Choose the crawler that you created in Step4 and click "Run Crawler"

## Validation Check

Verify the crawlwer configuration you creates; you can use the AWS cli or the Glue Console.
Note the Last Crawl status of SUCEEDED.

In the Glue console, select the table that was created and click "View Propertites".
You can also run an AWS CLI command to output the JSON.

```bash
aws glue get-table --datyabase-name awscookbook703 --name data
```

## Challenge

Configure your crawler to run on an interval so that your tables and metadata are automatically updated.