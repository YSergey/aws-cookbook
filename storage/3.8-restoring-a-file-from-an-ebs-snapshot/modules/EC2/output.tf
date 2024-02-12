#EC2-Aのスナップショット
output "ebs_volume_from_snapshot_id" {
  value = var.create_snap_shot ? aws_ebs_volume.ebs_volume_from_snapshot[0].id : null
}