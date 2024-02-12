#!/bin/bash
# read_env.sh

# .envファイルを読み込む
export $(cat .env | xargs)

# 環境変数をJSON形式で出力
echo "{"
echo "\"database_url\": \"$DATABASE_URL\","
echo "\"api_key\": \"$API_KEY\""
echo "}"
