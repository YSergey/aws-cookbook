# Kinesisストリームの作成
resource "aws_kinesis_stream" "example" {
  name        = var.stream_name
  shard_count = var.shard_count
}

# ストリームの検証
resource "null_resource" "verify_stream" {
  depends_on = [aws_kinesis_stream.example]

  provisioner "local-exec" {
    command = <<EOT
      # ストリームが存在するまで待機
      aws kinesis wait stream-exists --stream-name AWSCookbook701

      # レコードを挿入
      aws kinesis put-record --stream-name AWSCookbook701 --partition-key 111 --cli-binary-format raw-in-base64-out --data='{"Data":"1"}'

      # シャードイテレータを取得
      SHARD_ITERATOR=$(aws kinesis get-shard-iterator --shard-id $(aws kinesis list-shards --stream-name AWSCookbook701 --query Shards[0].ShardId --output text) --shard-iterator-type TRIM_HORIZON --stream-name AWSCookbook701 --query ShardIterator --output text)

      # レコードを取得してデコード
      RECORD_DATA=$(aws kinesis get-records --shard-iterator $SHARD_ITERATOR --query Records[0].Data --output text | base64 --decode)

      # 取得したレコードが期待通りか確認
      if [ "$RECORD_DATA" = "{\"Data\":\"1\"}" ]; then
        echo "Verification successful"
      else
        echo "Verification failed"
      fi
    EOT
  }
}