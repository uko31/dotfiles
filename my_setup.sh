#!/bin/bash

username="mika"

# test if root:
if [ "$(id -u)" != "0" ]; then
	echo "you need to be root => try again..."
	exit 1
fi

echo "create $username account [Y/n]:"
read c
[[ $c == "Y" || $c == "" ]] && useradd -m -s /bin/bash -g users $username

# set password:
passwd $username

# add user in sudoers
echo "$username ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# create default dirs for user:
# make sure the account exists:
[[ $(grep $username /etc/passwd) ]] || exit 3

[[ -d /home/$username/downloads     ]] || su $username -c "mkdir -pv /home/$username/downloads"
[[ -d /home/$username/data          ]] || su $username -c "mkdir -pv /home/$username/data"
# [[ -d /home/$username/nas           ]] || su $username -c "mkdir -pv /home/$username/nas"
[[ -d /home/$username/github        ]] || su $username -c "mkdir -pv /home/$username/github"
[[ -d /home/$username/usbdrives     ]] || su $username -c "mkdir -pv /home/$username/usbdrives"
[[ -d /home/$username/.config ]] || su $username -c "mkdir -pv /home/$username/.config"
[[ -d /home/$username/.config/awesome ]] || su $username -c "mkdir -pv /home/$username/.config/awesome"

# install a few things
pacman -Syu
pacman -S rxvt-unicode vim git mplayer opera nvidia xorg-server xorg-server-utils ffmpeg awesome vicious lightdm lightdm-gtk-greeter xcompmgr

# lightdm setup
cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.1
sed 's/#greeter-session=example-gtk-gnome/greeter-session=lightdm-gtk-greeter/' /etc/lightdm/lightdm.conf.1 > /etc/lightdm/lightdm.conf
systemctl enable lightdm

# X11 french keyboard setup
localectl set-x11-keymap fr

# git setup
cd /home/mika/github
su $username -c "git config --global user.name 'michaelis'"
su $username -c "git config --global user.email 'm.gregoriades@gmail.com'"
# get my dotfiles
su $username -c "git clone git@github.com:uko31/dotfiles.git"

# .Xresources update (this will require an X server restart)
su $username -c "cp /home/mika/github/dotfiles/.Xresources /home/$username"

# vim setup
echo "syntax on" >> /etc/vimrc
echo "set number" >> /etc/vimrc
echo "set tabstop=2" >> /etc/vimrc
echo "set shiftwidth=2" >> /etc/vimrc
echo "set expandtab" >> /etc/vimrc

# EOF
