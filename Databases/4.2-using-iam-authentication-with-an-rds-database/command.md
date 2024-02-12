- Regionの設定
    - export AWS_DEFAULT_REGION=$(curl --silent http://169.254.169.254/latest/dynamic/instance-identity/document | awk -F'"' '/region/ {print $4}')

- MySQlのインストール
    - sudo yum -y install mysql 
    - mysql -u clusteradmin -p -h hostname

- ユーザー作成
    - CREATE USER db_user@'%' IDENTIFIED WITH AWSAuthenticationPlugin as 'RDS'; 
    - GRANT SELECT ON *.* TO 'db_user'@'%';

- RDS Root CAの取得(デフォルトではrds-ca-rsa2048-g1だが、CookBookではrds-ca-2019を使用)
    - sudo wget https://truststore.pki.rds.amazonaws.com/us-west-2/us-west-2-bundle.pem
    - sudo wget https://s3.amazonaws.com/rds-downloads/rds-ca-2019-root.pem

- Token
    - TOKEN=$(aws rds generate-db-auth-token --hostname hostname --port 3306 --username db_user)

- db_user login
    - mysql --host=hostname --ssl-ca=us-west-2-bundle.pem --port=3306 --user=db_user --password=$TOKEN
    - mysql --host=hostname --ssl-ca=rds-ca-2019-root.pem --port=3306 --user=db_user --password=$TOKEN