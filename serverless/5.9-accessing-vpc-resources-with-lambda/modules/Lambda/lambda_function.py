import os
import uuid
import redis
import logging

# ログの設定
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    # Redis接続情報をログに記録
    hostname = os.environ.get('hostname')
    logger.info(f"Attempting to connect to Redis at {hostname}:6379")

    try:
        # Redisクライアントの初期化と接続テスト
        r = redis.Redis(host=hostname, port=6379, db=0)
        set_uuid = uuid.uuid4().hex
        r.set('uuid', set_uuid)
        get_uuid = r.get('uuid').decode('utf-8')  # Redisから取得したバイト列を文字列にデコード

        # 結果の検証
        if get_uuid == set_uuid:
            logger.info(f"Success: Got value {get_uuid} from Redis")
        else:
            logger.error(f"Retrieved value does not match set value. Got: {get_uuid}, Expected: {set_uuid}")
            raise Exception("Error: Retrieved value does not match set value")

    except Exception as e:
        # Redis接続や処理中にエラーが発生した場合はログに記録
        logger.error(f"Error connecting or operating with Redis: {e}")
        raise e

    return f"Got value from Redis: {get_uuid}"

