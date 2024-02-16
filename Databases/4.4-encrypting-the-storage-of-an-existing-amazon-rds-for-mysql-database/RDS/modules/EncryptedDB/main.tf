resource "aws_kms_key" "db_encryption" {
  description = "Key for RDS DB Encryption"
  deletion_window_in_days = 7

  tags = {
    Name = var.sysname
  }
}

resource "aws_kms_alias" "db_encryption_alias" {
  name          = "alias/my-db-encryption-key"
  target_key_id = aws_kms_key.db_encryption.key_id
}

resource "aws_db_instance" "read_replica" {
  replicate_source_db = var.replicate_source_db_id

  identifier         = "database-cluster-replica-instance"

  engine = var.engine
  engine_version = var.engine_version

  instance_class = var.instance_class
  db_subnet_group_name = var.db_subnet_group_name
}

resource "aws_db_snapshot" "replica_snapshot" {
  db_instance_identifier = aws_db_instance.read_replica.id
  db_snapshot_identifier = "my-read-replica-snapshot"
}

resource "aws_db_snapshot_copy" "encrypted_snapshot" {
  source_db_snapshot_identifier = aws_db_snapshot.replica_snapshot.db_snapshot_arn
  target_db_snapshot_identifier = "my-encrypted-snapshot"
  kms_key_id                    = aws_kms_key.db_encryption.arn

  depends_on = [aws_db_snapshot.replica_snapshot]
}

resource "aws_db_instance" "encrypted_db" {
  snapshot_identifier = aws_db_snapshot_copy.encrypted_snapshot.id

  identifier         = "database-cluster-encrypted-instance"

  engine = var.engine
  engine_version = var.engine_version

  instance_class = var.instance_class
  db_subnet_group_name = var.db_subnet_group_name

  kms_key_id              = aws_kms_key.db_encryption.arn

  depends_on = [aws_db_snapshot_copy.encrypted_snapshot]
}