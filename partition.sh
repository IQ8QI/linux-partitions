#!/bin/bash

fdisk /dev/nvme0n1

cryptsetup -y luksFormat /dev/nvme0n1p2
cryptsetup luksOpen /dev/nvme0n1p2 luksnvme0n1p2

pvcreate /dev/mapper/luksnvme0n1p2
vgcreate cryptvg /dev/mapper/luksnvme0n1p2
lvcreate -L 64G -n root cryptvg
lvcreate -L 24G -n swap cryptvg
lvcreate -l 100%FREE -n home cryptvg

mkfs.fat -F 32 /dev/nvme0n1p1
mkfs.btrfs /dev/cryptvg/home
mkfs.btrfs /dev/cryptvg/root
mkswap /dev/cryptvg/swap
swapon /dev/cryptvg/swap
