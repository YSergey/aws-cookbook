import json
import base64

def lambda_handler(event, context):
    for record in event['Records']:
        # Kinesisデータのbase64デコード
        payload = base64.b64decode(record['kinesis']['data'])
        # JSONとしてパース
        data = json.loads(payload)
        # データの処理（例：ログ出力）
        print(f"Received data: {data}")
        # ここに追加の処理ロジックを記述
    return {'statusCode': 200}