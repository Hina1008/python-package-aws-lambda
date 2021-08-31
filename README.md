# python-package-aws-lambda
aws lambdaに必要なパッケージを入れるためのDocker環境作り

# 実行環境
以下の環境を使用
## 1-a. Windows (OS: Windows10)
- wsl2: Ubuntu-20.04
- docker desktop

**WSL2**と**Docker**が用意されていない場合は、以下のURLを参考にして、インストールを行う。\
https://tech-lab.sios.jp/archives/18811

## 1-b. Mac (OS: macOS Big Sur Ver.11.5.2)
- Homebrew
- docker

**Homebrew**と**docker**が用意されてない場合は、以下を参考として、インストールを行う。

### [Homebrew](https://brew.sh/index_ja)
以下のURLからインストールする\
https://brew.sh/index_ja
### Docker
`brew install --cask docker`をターミナル上で実行する。
インストール完了後、アプリを起動。\
⇨リソース（ メモリやストレージなど ）の割り当て設定を確認、調整を行う
ターミナル上で、`docker --version`を実行し、Dockerのバージョンを確認する。

# 使い方
# **docker hub**から**amazonlinux**のイメージを持ってくる
https://hub.docker.com/_/amazonlinux?tab=tags&page=1&ordering=last_updated
```
docker pull amazonlinux:2
docker images
-------------------------------------------------------------
REPOSITORY      TAG      IMAGE ID         CREATED       SIZE
amazonlinux      2      xxxxxxxxx     x seconds ago    163MB
-------------------------------------------------------------
```
## git cloneでローカルに持ってくる
```
git clone https://github.com/Hina1008/python-package-aws-lambda
```
## ディレクトリ構造
```
python-package-aws-lambda
├── Dockerfile
├── README.md
├── deploy
│   ├── python
│   └── requirements.txt
└── docker-compose.yml
```







