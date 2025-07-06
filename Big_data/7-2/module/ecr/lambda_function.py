import json
import base64

def lambda_handler(event, context):
    outputs = []
    for record in event['records']:
        # 受信データのデコード
        payload = base64.b64decode(record['data'])
        data = json.loads(payload)
        
        # 例: 'sensitive_field'というフィールドを削除
        if 'sensitive_field' in data:
            del data['sensitive_field']
        
        # 変換後のデータをエンコードして出力
        output = {'recordId': record['recordId'], 'result': 'Ok', 'data': base64.b64encode(json.dumps(data).encode()).decode()}
        outputs.append(output)
    
    return {'records': outputs}