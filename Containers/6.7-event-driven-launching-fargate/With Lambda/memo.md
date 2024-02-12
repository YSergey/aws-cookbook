結局ECSをEvent Drivenにして何が嬉しいの？

EventBrigeでのよく使うトリガー
    Amazon S3:
        オブジェクトの作成（Put、Post、Copy、CompleteMultipartUploadなど）
        オブジェクトの削除

    Amazon EC2:
        インスタンスの状態変更（起動、停止、終了など）
        スナップショット作成完了

    AWS Lambda:
        関数の実行

    Amazon DynamoDB:
        テーブル更新
        ストリームイベント

    AWS Step Functions:
        ステートマシンの実行状態の変更

    Amazon RDS:
        データベースインスタンスのステータス変更

    Amazon ECS:
        タスクの状態変更
        サービスの状態変更

    AWS CodePipeline:
        パイプラインの実行ステータスの変更

    AWS CodeBuild:
        ビルドプロジェクトの実行結果

    Amazon CloudWatch Alarms:
        アラームの状態変更