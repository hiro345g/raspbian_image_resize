#!/bin/sh
#
# 使い方
#
# $ LANG=C sudo sh rpi_image_resize.sh <file_name>
#

# イメージファイル名の指定
image=raspbian.img
if [ $# -eq 1 ]; then
  image=$1
fi

# パーティション番号の取得
partion_no=$(parted -m $image unit B print | grep ext4 | python3 -c "import sys; print([x for x in input().split(':')][0])")
# パーティションの開始位置の取得
start=$(parted -m $image unit B print | grep ext4 | python3 -c "import sys; print([x for x in input().split(':')][1].replace('B', ''))")
# 現在のサイズ
current_size=$(parted -m $image unit B print | grep ext4 | python3 -c "import sys; print([x for x in input().split(':')][2].replace('B', ''))")

# ループバックデバイスとして設定してリサイズのための情報を取得
loopback=$(losetup -f --show -o $start $image);
echo "loopback: $loopback"
e2fsck -p -f $loopback
size=$(resize2fs -P $loopback | python3 -c "import sys; print(str(int([x for x in input().split(':')][1])))")
size=$(echo $size+1024 | bc)
resize2fs -p $loopback $size
sleep 1
losetup -d $loopback

# 現在のパーティションを削除して新しいパーティションを作成
size=$(echo ${size}*4096+${start} | bc)
parted $image rm $partion_no
parted -s $image unit B mkpart primary $start $size

# 新しいパーティションを縮小
size=$(echo ${size}+58720257 | bc)
truncate -s $size $image


