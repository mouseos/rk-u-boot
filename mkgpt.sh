#!/bin/bash

# ディスクイメージファイルのパス
img_path="gpt.img"

echo "Creating empty image file"
dd if=/dev/zero of=$img_path bs=300M count=1
echo "Creating gpt table"
parted -s gpt.img mklabel gpt

echo "=========== Create partitions =========="
echo "Creating idbloader"
echo "n
1
64
16383
w" | fdisk $img_path

echo "Creating uboot"
echo "n
2
16384
24575
w" | fdisk $img_path

echo "Creating trust"
echo "n
3
24576
32767
w" | fdisk $img_path

echo "Creating boot"
echo "n
4
32768
262143
w" | fdisk $img_path

echo "Creating rootfs"
echo "n
5
262144
600000
w" | fdisk $img_path


echo "=========== Set partition name =========="
sgdisk -c 1:"idbloader"  ${img_path}
sgdisk -c 2:"u-boot"  ${img_path}
sgdisk -c 3:"trust"  ${img_path}
sgdisk -c 4:"boot"  ${img_path}
sgdisk -c 5:"rootfs"  ${img_path}
