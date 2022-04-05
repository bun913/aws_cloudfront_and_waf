# ALBの前にWAF, WAFの前にCloudFrontを配置してセキュアな構成のアプリにしてみる

## 構成

![構成図](/infra/docs/images/system_archi.png)

ユーザーのアクセスを WAF -> CloudFront -> ALB(静的アセットはS3) となるように設定する。

この構成のメリット

- WAFで不審なアクセスを遮断
- CloudFrontでDDOS攻撃対策

## 今回のスコープ

### やること

- ECSでサンプルアプリを稼働させる
- ALBの前にCloudFrontを配置。最近使えるようになったManagedPrefixListでALBへのアクセスをCloudFrontに制限
  - https://blog.serverworks.co.jp/2022/02/09/cloudfront_aws_managed_prefix_list
- WAFをCloudFrontの前に配置。とりあえずMangedRuleで不審な通信を遮断する

### やらないこと

- ECSサービスのCI・CD

## 手順

### 事前準備

事前に今回HTTPS通信で利用するためのドメイン名を取得しておく。

### globalリソースの作成

```bash
cd infra/global
terraform init
terraform plan
terraform apply
```

### DNS周りの設定

今回取得したドメイン名がRoute53以外のものであるため、取得したドメイン元でnameserverの設定をRoute53に向ける設定を行う。

（手順は省略)

### サンプルアプリケーションのイメージをECRにプッシュする

今回はこちらのリポジトリのサンプルアプリケーションを利用する。

https://github.com/bun913/sample_app

このリポジトリをPullして、そのディレクトリのルートで以下のようにシェルスクリプトを実行

```bash
./push_image.sh sample
```

これによりECRにv1というタグでアプリがプッシュされたことを確認する

### productionリソースの作成

```bash
cd infra/production
terraform init
terraform plan
terraform apply
```

##　動作確認

### WAFが適用されているか確認

```bash
# これなら帰ってくる
curl --location --request GET 'https://cdn.hoge.com' \
--header 'User-Agent: test'
# これはステータスコード403でレスポンス
curl --location --request GET 'https://cdn.hoge.com' -H 'User-Agent: '
```

### ALBへのアクセスはCloudFront経由でしかできないことを確認

```bash
# CloudFront経由はアクセスできる
curl --location --request GET 'https://cdn.hoge.com' \
--header 'User-Agent: test'

# ALBのドメイン名直はアクセスできない
curl --location --request GET 'https://alb.hoge.com' \
--header 'User-Agent: test'
```

### S3へのアクセスはCDN経由でしかできないことを確認

```bash
# CloudFront経由はアクセスできる
curl --location --request GET https://hoge.com/static/test.json
# S3直接はアクセスできない
curl --location --request GET https://${S3のDNS名}/static/test.json
```
