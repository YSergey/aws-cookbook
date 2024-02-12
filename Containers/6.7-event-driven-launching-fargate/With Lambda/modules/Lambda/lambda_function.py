import os
import boto3
import json

def lambda_handler(event, context):
    # 環境変数からECS関連の設定を取得
    ecs_cluster_name = os.environ.get('ECS_CLUSTER_NAME')
    task_definition = os.environ.get('ECS_TASK_DEFINITION')
    subnet_ids_str = os.environ.get('ECS_SUBNET_ID')
    container_name = os.environ.get('CONTAINER_NAME')

    # サブネットIDの文字列をリストに変換
    subnet_ids = subnet_ids_str.split(',') if subnet_ids_str else []

    ecs_client = boto3.client('ecs')

    # S3イベントからバケット名とオブジェクトキーを取得
    bucket_name = event['detail']['bucket']['name']
    object_key = event['detail']['object']['key']

    print(f"Bucket: {bucket_name}, Key: {object_key}")

    # ECSタスクを実行
    response = ecs_client.run_task(
        cluster=ecs_cluster_name,
        launchType='FARGATE',
        taskDefinition=task_definition,
        networkConfiguration={
            'awsvpcConfiguration': {
                'subnets': subnet_ids,
                'assignPublicIp': 'ENABLED'
            }
        },
        overrides={
            'containerOverrides': [{
                'name': container_name,  # コンテナ定義の名前
                'environment': [
                    {'name': 'S3_BUCKET', 'value': bucket_name},
                    {'name': 'S3_KEY', 'value': object_key}
                ]
            }]
        }
    )

    # レスポンスをログに記録
    print("Task ARN:", response.get('tasks', [{}])[0].get('taskArn', 'Unknown'))

    return {
        'statusCode': 200,
        'body': json.dumps('ECS task triggered successfully.')
    }
