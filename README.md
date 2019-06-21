# Raspbian image resize

RaspbianのバックアップをmicroSDカードへディスクイメージでとってあるときに、そのサイズを小さくすることができます。


## 必要な環境

Ubuntu18.04で動作確認をしています。下記コマンドが使えれば大丈夫なはずです。

- Linux
  - bash
  - bc
  - e2fsck
  - echo
  - grep
  - losetup
  - parted
  - resize2fs
  - sleep
  - truncate
- python3


## 使い方

LANG=Cの環境変数を指定して利用するようにしてください。また、root権限のスクリプト実行が必要です。

バックアップのディスクイメージファイル名が/home/pi/raspbian_image_20190101.imgだとすると、次のように実行します。

```
$ LANG=C sudo bash rpi_image_resize.sh /home/pi/raspbian_image_20190101.img
```

raspbian_image_20190101.imgのファイルサイズが小さくなりますから、もし心配なら、あらかじめ別途バックアップをしておいてください。一度、小さくしたディスクイメージファイルをmicroSDカードへ書き込んで、それが動くことを確認してみた方が良いでしょう。

## イメージファイルからmicroSDカードを作成する方法

microSDカードに書き込む方法はいくつかありますが、ここではddコマンドを使う方法を紹介します。

USBカードリーダーにmicroSDカードを挿れたものをLinuxが/dev/sdbと認識しているとします。

例えば、microSDカードをつけたUSBカードリーダーをLinuxマシンへ挿したときに、/media/boot, /media/rootfs へ自動マウントされているとします。

次のように実行すると/home/pi/raspbian_image_20190101.imgのディスクイメージをmicroSDカードへ書き込むことができます。

```
$ sudo umount /media/boot
$ sudo umount /media/rootfs
$ sudo dd if=/dev/sdb of=/home/pi/raspbian_image_20190101.img bs=4M
```

これで作成したサイズの小さいディスクイメージをmicroSDカードに書き込んだとします。それを使ってRaspbianが起動したら、必ず最初にraspi-configコマンドを使ってファイルシステムを拡張してください。拡張したら、再起動します。

```
$ sudo raspi-config --expand-rootfs
$ sudo reboot
```


## バックアップのとり方

バックアップのイメージは、あらかじめddコマンドで取っておきます。

USBカードリーダーにmicroSDカードを挿れたものをLinuxが/dev/sdbと認識しているとします。

例えば、microSDカードをつけたUSBカードリーダーをLinuxマシンへ挿したときに、/media/boot, /media/rootfs へ自動マウントされているとします。

また、

次のように実行すると/home/pi/raspbian_image_20190101.imgへバックアップのディスクイメージがとれます。


```
$ sudo umount /media/boot
$ sudo umount /media/rootfs
$ sudo dd if=/dev/sdb of=/home/pi/raspbian_image_20190101.img bs=4M
```


## 参考資料

下記にPerlを使ったスクリプトがあります。これを参考にして、Pythonを使ったバージョンを作成しました。

- https://www.raspberrypi.org/forums/viewtopic.php?t=58069
