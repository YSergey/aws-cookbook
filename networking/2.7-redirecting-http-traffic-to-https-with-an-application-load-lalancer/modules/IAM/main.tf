resource "aws_iam_server_certificate" "my_cert" {
  name_prefix      = "my-server-cert" # 名前のプレフィックスを適切に設定してください
  private_key      = file("./modules/IAM/cert/my-private-key.pem") # プライベートキーのパスを適切に設定してください
  certificate_body = file("./modules/IAM/cert/my-certificate.pem") # 証明書のパスを適切に設定してください
}
