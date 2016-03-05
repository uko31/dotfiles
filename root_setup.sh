#!/bin/bash

username="mika"
hostname="blackbox"

# test if root:
if [ "$(id -u)" != "0" ]; then
	echo "you need to be root => try again..."
	exit 1
fi

# init locale
cp /etc/locale.gen /etc/locale.gen.1
sed 's/#fr_FR.UTF-8 UTF-8/fr_FR.UTF-8 UTF-8/' /etc/locale.gen.1 > /etc/locale.gen
locale-gen
echo "LANG=fr_FR.UTF-8" > /etc/locale.conf
echo "KEYMAP=fr-latin1" > /etc/vconsole.conf
echo "FONT=lat9w-16" >> /etc/vconsole.conf

# set time
ln -s /usr/share/zoneinfo/Europe/Paris /etc/localtime
hwclock --systohc --utc

# set initramfs
cp /etc/mkinitcpio.conf /etc/mkinitcpio.conf.1
sed 's/modconf block filesystems keyboard/modconf block lvm2 filesystems keyboard/' /etc/mkinitcpio.conf.1 > /etc/mkinitcpio.conf
mkinitcpio -p linux

# loader installation and setup
pacman -S grub
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# network configuration
cp /etc/netctl/examples/ethernet-static /etc/netctl/home
sed "s/eth0/enp3s0/; s/192.168.1.23/192.168.1.5/; s/ '192.168.1.87\/24'//; s/Gateway='192.168.1.1'/Gateway='192.168.1.254'/; s/DNS=('192.168.1.1')/DNS=('192.168.1.254')/" /etc/netctl/examples/ethernet-static > /etc/netctl/home
netctl enable home

# gestion du umount du /var
echo "Storage=volatile" >> /etc/systemd/journald.conf

# set hostname:
hostnamectl set-hostname $hostname

# set root password:
echo "root password:"
passwd

echo "you have to reboot"

