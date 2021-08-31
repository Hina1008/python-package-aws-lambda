# AWS Lambdaを使うための 環境作り
aws lambdaでOS依存のパッケージを使うための環境作り\
パッケージの中には(**Pillow**, **mecab**等)、OS依存のパッケージがある。\
それらを、AWS LambdaのLayerにdeployすることを目標とする。


# 実行環境
## Windows (OS: Windows10)
- wsl2: Ubuntu-20.04
- docker desktop

**WSL2**と**Docker**が用意されていない場合は、以下のURLを参考にして、インストールを行う。\
https://tech-lab.sios.jp/archives/18811

## Mac (OS: macOS Big Sur Ver.11.5.2)
- Homebrew
- docker

**Homebrew**と**docker**が用意されてない場合は、以下を参考として、インストールを行う。

### Homebrew
以下のURLからインストールする\
https://brew.sh/index_ja
### Docker
dockerのインストール
```
brew install --cask docker
```
インストール完了後、アプリを起動.\
⇨リソース（ メモリやストレージなど ）の割り当て設定を確認、調整を行う\
バージョンの確認.
```
docker --version
```

# 使い方
# 1.**docker hub**から**amazonlinux**のイメージを持ってくる
[AWS Lambdaランタイム](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/lambda-runtimes.html)\
[docker hub:amazonlinux](https://hub.docker.com/_/amazonlinux?tab=tags&page=1&ordering=last_updated)
```
docker pull amazonlinux:2
```
```
docker images
```
```
-------------------------------------------------------------
REPOSITORY      TAG      IMAGE ID         CREATED       SIZE
amazonlinux      2      xxxxxxxxx     x seconds ago    163MB
-------------------------------------------------------------
```
## 2.git cloneでローカルに持ってくる
```
git clone https://github.com/Hina1008/python-package-aws-lambda
```
### ディレクトリ構造
```
python-package-aws-lambda
├── Dockerfile
├── README.md
├── deploy
│   ├── python
│   └── requirements.txt
└── docker-compose.yml
```
## 3.requirements.txtにインストールしたいライブラリ名を記述
requirements.txt(デフォルトでboto3のみを記述している.)
```
boto3==1.18.32
```
例1:requirements.txt
```
boto3==1.18.32
mecab-python3==version
ipadic==version
```
例2:requirements.txt
```
boto3==1.18.32
Pillow==version
```
## 4.dockerを立ち上げて実行
```
docker-compose up --build
```
## 5.python以下をzipで圧縮を行う
```
cd deploy
```
**python/** 以下のパッケージを圧縮する.
```
zip -r file.zip python/
```
zipファイルの中身を確認
```
unzip -t file.zip
```
```
-----------------------------------------
Archive:  file.zip
    testing: python/                  OK
    testing: python/.gitkeep          OK
    testing: python/<package>.        OK
    ...
-----------------------------------------
```






