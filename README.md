# AWS Lambdaを使うための環境作り(OS依存のパッケージをLayerに追加する)
aws lambdaでOS依存のパッケージを使うための環境作り\
パッケージの中には(**Pillow**, **mecab**等)、OS依存のパッケージがある。\
それらを、AWS LambdaのLayerにdeployすることを目標とする。

# 目次
- 実行環境
    - Windowsでの開発環境構築
    - Macでの開発環境構築
- 手順
    1. **docker hub**から**amazonlinux**のイメージを持ってくる
    2. git cloneでローカルに持ってくる
    3. requirements.txtにインストールしたいライブラリ名を記述
    4. dockerを立ち上げて実行
    5. python以下をzipで圧縮を行う(アプリで圧縮する場合は、スキップ)
    6. AWS Lambdaのレイヤーにzip化したファイルをアップロードする
    7. AWS Lambdaの関数を作成
    8. AWS Lambdaの関数で追加したレイヤーのライブラリをimportする方法　（完了）

# 実行環境
## Windows (OS: Windows10)
- wsl2: Ubuntu-20.04
- docker desktop
- zip(ソフト(アプリ)でも可能)

### WSL2,Docker
**WSL2**と**Docker**が用意されていない場合は、以下のURLを参考にして、インストールを行う。\
https://tech-lab.sios.jp/archives/18811

### zip
1. apt-getでのインストール \
   wsl2のターミナルで以下のコマンドを実行
   ```
   sudo apt-get install zip unzip
   ```
2. brewでのインストール \
    brewをインストールしていない場合,wsl2のターミナルで以下のコマンドを実行
    ```
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    ```
    
    ```==> Installation successful!```
    と出力されれば、インストール完了
    
    brewインストール後、以下のコマンドを実行
    ```
    brew install zip
    ```


## Mac (OS: macOS Big Sur Ver.11.5.2)
- Homebrew
- docker
- zip(ソフト(アプリ)でも可能)

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

### Zip
以下のコマンドを実行
```
brew install zip
```

# 手順
# 1.**docker hub**から**amazonlinux**のイメージを持ってくる
[AWS Lambdaランタイム](https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/lambda-runtimes.html) \
[docker hub:amazonlinux](https://hub.docker.com/_/amazonlinux?tab=tags&page=1&ordering=last_updated) \
ここでは、ランタイム(python3.8)を使うので、amazonlinux2のイメージを持ってくる
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

# 2.git cloneでローカルに持ってくる
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
# 3.requirements.txtにインストールしたいライブラリ名を記述
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
# 4.dockerを立ち上げて実行
```
docker-compose up --build
```
# 5.python以下をzipで圧縮を行う(アプリで圧縮する場合は、スキップ)

deployディレクトリへ移動する.
```
cd deploy
```
移動後、**python/** ディレクトリをzipコマンドで圧縮する.
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
# 6.AWS Lambdaのレイヤーにzip化したファイルをアップロードする
1. AWS Lambdaを開く
2. 下記のイメージのように、レイヤーを選択
![スクリーンショット 2021-09-19 16 21 35](https://user-images.githubusercontent.com/40563830/133919140-11017a60-6d72-45bc-afdf-5f366894315c.png)
3. 下記のイメージのように、レイヤーの作成を選択
![スクリーンショット 2021-09-19 16 33 24](https://user-images.githubusercontent.com/40563830/133919402-8cff74f2-1b39-439d-8a48-5b0b0cfdd3b7.png)
4. 下記のイメージを参考にレイヤーの作成
    - 名前(必須)
    - 説明-オプション(任意)
    - .zip ファイルをアップロード\
        アップロード(5.で作成したzipファイルを選択する)
    - ランタイム\
        以下のURLを参考にして、使用するランタイムを設定する.\
        https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/lambda-runtimes.html \
        ここでは、python3.8をランタイムにする.
![スクリーンショット 2021-09-19 16 44 55](https://user-images.githubusercontent.com/40563830/133919627-1de0f61f-5f32-4b70-b22b-00dee02d5318.png)
5. 作成完了
![スクリーンショット 2021-09-19 16 54 38](https://user-images.githubusercontent.com/40563830/133919905-1feeab86-aa6f-44dd-80a6-25a315d744c5.png)

# 7.AWS Lambdaの関数を作成
1. 下記のイメージのように、関数の作成を選択
![スクリーンショット 2021-09-19 16 57 17](https://user-images.githubusercontent.com/40563830/133919972-68e43f44-9582-455b-a088-735e89ed4c22.png)
2. 下記のイメージを参考に関数を作成
    - 名前(必須)
    - ランタイム(必須)
        以下のURLを参考にして、使用するランタイムを設定する.\
        https://docs.aws.amazon.com/ja_jp/lambda/latest/dg/lambda-runtimes.html \
        ここでは、python3.8をランタイムにする.
    - 他デフォルトとする
![スクリーンショット 2021-09-19 17 00 13](https://user-images.githubusercontent.com/40563830/133920078-53966d16-fb1d-4a74-8f53-2e7d462ffc59.png)
3. 作成すると、以下のイメージのように作成した関数が開く
![スクリーンショット 2021-09-19 17 03 54](https://user-images.githubusercontent.com/40563830/133920155-3669421b-40c4-4f22-abc8-282ec910e85c.png)
5. 上記のサイトを下にスクロールしていくと、レイヤーの追加できるカラムが出てくる
![スクリーンショット 2021-09-19 17 06 37](https://user-images.githubusercontent.com/40563830/133920229-17df4b0a-39bd-4c45-b52c-e9dd222baefe.png)
7. 下記のイメージを参考にレイヤーを追加する
    - レイヤーソース
        カスタムレイヤー
    - カスタムレイヤー
        先ほど作成したレイヤー \
        ここでは、function-package
    - バージョン
        1(レイヤーを最初に作成した際は、バージョン1のみ存在)
![スクリーンショット 2021-09-19 17 08 16](https://user-images.githubusercontent.com/40563830/133920260-02986f91-208b-439e-9e18-c019f5af50f0.png)

# 8.AWS Lambdaの関数で追加したレイヤーのライブラリをimportする方法
通常の使い方と同じ\
例1) Mecabを使用するとき
```
import MeCab
```
例2) PILを使用するとき
```
from PIL import Image
```





