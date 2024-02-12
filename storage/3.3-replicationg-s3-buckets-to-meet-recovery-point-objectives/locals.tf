locals {
    s3 = {
        sysname = "replicating-s3-buckets-to-meet-recovery-point-objectives"
        bucket_name = "my-unique-bucket-name-for-aws-cookbook-3.3"
        object_ownership = "BucketOwnerPreferred"
        acl = "private"
    }
}