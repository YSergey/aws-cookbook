locals {
    s3 = {
        sysname = "robserving-s3-storage-and-access-metrics-using-storage-lens"
        bucket_name = "my-unique-bucket-name-for-aws-cookbook-3.4"
        object_ownership = "BucketOwnerPreferred"
        acl = "private"
    }
}