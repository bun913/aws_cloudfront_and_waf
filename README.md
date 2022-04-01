# ALBの前にWAF, WAFの前にCloudFrontを配置してセキュアな構成のアプリにしてみる

## 構成

WIP

## 今回のスコープ

### やること


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