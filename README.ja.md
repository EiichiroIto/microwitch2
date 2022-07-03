# micro:witch2
micro:witch2はBBC micro:bit用のブロック型プログラミング環境です。

micro:witch2は[micro:witch](https://github.com/EiichiroIto/microwitch)の後継であり、Pharo Smalltalk 10で実装されています。

![screenshot1](https://github.com/EiichiroIto/microwitch2/raw/main/misc/PharoScreenshot.png)

## micro:witch2の特長
- 比較的低機能なPCでも動作します。
- Windows 10以上で動作します。
- アプリの実行にインターネット接続は不要です。
- PCへのインストールが不要です。（USBメモリから起動できます）
- 接続されたmicro:bitを自動的に見つけます。
- micro:bitに接続した状態でプログラムを実行できます。
- micro:bitに接続しない状態でも転送したプログラムを実行できます。
- 比較的プログラムの転送時間が短いです。
- micro:bitの初期化（ファームウェアの転送）が必要です。（メニューから実行できます）
- メッセージが日本語化されています。
- 拡張モジュールを記述したり、ブロックを増やせます。

## Windows版インストール
1. [release page](https://github.com/EiichiroIto/microwitch2/releases)を開いて、Assetsから最新のリリースファイル（末尾がjpの圧縮ファイル）をダウンロードします。
2. 圧縮ファイルを展開します。
3. 展開したフォルダ内の microwitch.exe をダブルクリックすればアプリケーションが起動します。

## micro:bitを初期化する
1. micro:witch2を起動します。（上記参照）
2. micro:bitをPCに接続します。
3. micro:bitがPCに認識されるまで待ちます。
4. ツールメニューから「micro:bitを初期化する」を選びます。
5. 「はい」を押してmicro:bitを初期化します。
6. 再びmicro:bitがPCに認識されるまで待ちます。

## 始めかた
1. micro:witch2を起動します。
2. micro:bitをPCに接続します。
3. 画面左上で「表示」カテゴリをクリックします。
4. 「Helloをスクロール表示する」ブロックをドラッグして、右側の場所にドロップします。
5. ブロックをダブルクリックすると、micro:bitに「Hello」と表示されます。

## Pharo用のリポジトリ
micro:witch2のソースはgithub (https://github.com/EiichiroIto/microwitch2/) にあります。

```
Metacello new
    baseline: 'Microwitch';
    repository: 'github://EiichiroIto/microwitch2/src';
    load.
```

## 制限
- micro:bitのシミュレーターはありません。

## ライセンス
- MIT LICENSE

