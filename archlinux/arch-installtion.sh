#!/bin/sh
## This script should be run with root,
## you need to check internet connection and manually do disk partition before use

##  ==================== configuration ========================
HOSTNAME='xuranus'
USERNAME='xuranus'
BOOT_PARTITION='/dev/sda1' # spare about 500MB boot partition
ROOT_PARTITION='/dev/sda2'
## =============================================================

mkfs.ext4 $ROOT_PARTITION
mkdir /mnt
mount $ROOT_PARTITION /mnt

mkfs.fat -F32 $BOOT_PARTITION
mkdir /mnt/boot
mount $BOOT_PARTITION /mnt/boot

## update system time
timedatectl set-ntp true

## set mirror
echo '## aliyun' >> /etc/pacman.d/mirrorlist
echo 'Server = http://mirrors.aliyun.com/archlinux/$repo/os/$arch'
 >> /etc/pacman.d/mirrorlist

## install basic system
pacstrap /mnt base linux linux-firmware

## generate fstab in order to mount partition automatically when system start
genfstab -U /mnt >> /mnt/etc/fstab

## change root to new installed system
arch-chroot /mnt /bin/bash

## configure timezone
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
hwclock --systohc --utc

## configure language
/etc/locale.gen
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
echo 'zh_CN.UTF-8 UTF-8' >> /etc/locale.gen
locale-gen

echo LANG=en_US.UTF-8 > /etc/locale.conf
echo $HOSTNAME > /etc/hostname
echo '127.0.0.1	localhost.localdomain	localhost' >> /etc/hosts
echo '::1		localhost.localdomain	localhost' >> /etc/hosts
echo  '127.0.1.1	'$HOSTNAME'.localdomain  '$HOSTNAME >> /etc/hosts

## configure passwd
passwd

## boot program
pacman -S intel-ucode
## BIOS：  
## pacman -S grub os-prober  
## grub-install --target=i386-pc /dev/sda  
## grub-mkconfig -o /boot/grub/grub.cfg  
## UEFI：  
pacman -S efibootmgr dosfstools grub os-prober --noconfirm
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub  
grub-mkconfig -o /boot/grub/grub.cfg  

## create new user
pacman -S zsh --noconfirm
useradd -m -G wheel -s /bin/zsh $USERNAME
passwd $USERNAME

pacman -S sudo --noconfirm
echo $USERNAME' ALL=(ALL) ALL' >> /etc/sudoers

## install desktop enviroment
pacman -S xorg --noconfirm
pacman -S plasma kde-applications sddm --noconfirm
pacman -S networkmanager --noconfirm
pacman -S wqy-microhei --noconfirm

systemctl enable sddm
systemctl enable NetworkManager

## reboot
umount -R /mnt
reboot