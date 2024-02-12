locals {
    s3 = {
        sysname = "using-lifecycle-policies-to-reduce-storage-costs"
        bucket_name = "my-unique-bucket-name-for-aws-cookbook-3.1"
        object_ownership = "BucketOwnerPreferred"
        acl = "private"
    }
}