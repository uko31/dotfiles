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
[[ -d /home/$username/nas           ]] || su $username -c "mkdir -pv /home/$username/nas"
[[ -d /home/$username/github        ]] || su $username -c "mkdir -pv /home/$username/github"
[[ -d /home/$username/usbdrives     ]] || su $username -c "mkdir -pv /home/$username/usbdrives"
[[ -d /home/$username/usbdrives/xhd ]] || su $username -c "mkdir -pv /home/$username/usbdrives/xhd"
[[ -d /home/$username/usbdrives/key ]] || su $username -c "mkdir -pv /home/$username/usbdrives/key"
[[ -d /home/$username/.config ]] || su $username -c "mkdir -pv /home/$username/.config"
[[ -d /home/$username/.config/awesome ]] || su $username -c "mkdir -pv /home/$username/.config/awesome"

# install a few things
pacman -Syu

pacman -S rxvt-unicode vim git mplayer opera nvidia xorg-server xorg-server-utils ffmpeg

pacman -S awesome vicious lightdm lightdm-gtk-greeter xcompmgr

cp /etc/lightdm/lightdm.conf /etc/lightdm/lightdm.conf.1
sed 's/#greeter-session=example-gtk-gnome/greeter-session=lightdm-gtk-greeter/' /etc/lightdm/lightdm.conf.1 > /etc/lightdm/lightdm.conf

systemctl enable lightdm

localectl set-x11-keymap fr

# configuration de Xresources

echo "*background: #282828" >> /home/$username/.Xresources
echo "*foreground: #eeeeec" >> /home/$username/.Xresources
echo "! black"              >> /home/$username/.Xresources
echo "*color0: #333333 "    >> /home/$username/.Xresources
echo "*color8: #777777"     >> /home/$username/.Xresources
echo "! red"                >> /home/$username/.Xresources
echo "*color1: #ff78a3"     >> /home/$username/.Xresources
echo "*color9: #ffa0be"     >> /home/$username/.Xresources
echo "! green"              >> /home/$username/.Xresources
echo "*color2: #b6ff93"     >> /home/$username/.Xresources
echo "*color10: #bdff9d"    >> /home/$username/.Xresources
echo "! yellow"             >> /home/$username/.Xresources
echo "*color3: #ffd378"     >> /home/$username/.Xresources
echo "*color11: #ffe0a0"    >> /home/$username/.Xresources
echo "! blue"               >> /home/$username/.Xresources
echo "*color4: #78a4ff"     >> /home/$username/.Xresources
echo "*color12: #93b6ff"    >> /home/$username/.Xresources
echo "! magenta"            >> /home/$username/.Xresources
echo "*color5: #8f78ff"     >> /home/$username/.Xresources
echo "*color13: #b0a0ff"    >> /home/$username/.Xresources
echo "! cyan"               >> /home/$username/.Xresources
echo "*color6: #78e7ff"     >> /home/$username/.Xresources
echo "*color14: #a0eeff"    >> /home/$username/.Xresources
echo "! white"              >> /home/$username/.Xresources
echo "*color7: #cccbca"     >> /home/$username/.Xresources
echo "*color15: #fcfcfc"    >> /home/$username/.Xresources
echo "Xft.lcdfilter                :  lcddefault"                   >> /home/$username/.Xresources
echo "Xft.hintstyle                :  hintslight"                   >> /home/$username/.Xresources
echo "Xft.hinting                  :  1"                            >> /home/$username/.Xresources
echo "Xft.autohint                 :  1"                            >> /home/$username/.Xresources
echo "Xft.antialias                :  1"                            >> /home/$username/.Xresources
echo "Xft.dpi                      :  96"                           >> /home/$username/.Xresources
echo "Xft.rgba                     :  rgb"                          >> /home/$username/.Xresources
echo "Xcursor.theme                :  Vanilla-DMZ-AA"               >> /home/$username/.Xresources
echo "URxvt.font                   :  xft:monospace:size=10"        >> /home/$username/.Xresources
echo "URxvt.boldFont               :  xft:monospace:bold:size=10"   >> /home/$username/.Xresources
echo "URxvt.scrollBar              :  false"                        >> /home/$username/.Xresources
echo "URxvt.buffered               :  true"                         >> /home/$username/.Xresources
echo "URxvt.perl-ext-common        :  default,tabbedex,clipboard"   >> /home/$username/.Xresources
echo "URXVT.iso14755               :  false"                        >> /home/$username/.Xresources
echo "URxvt.tabbed.tabbar-fg       :  8"                            >> /home/$username/.Xresources
echo "URxvt.tabbed.tabbar-bg       :  0"                            >> /home/$username/.Xresources
echo "URxvt.tabbed.tab-fg          :  15"                           >> /home/$username/.Xresources
echo "URxvt.tabbed.tab-bg          :  0"                            >> /home/$username/.Xresources
echo "URxvt.tabbed.autohide        :  true"                         >> /home/$username/.Xresources
echo "URXvt.tabbed.reopen-on-close :  yes"                          >> /home/$username/.Xresources
echo "URxvt.perl-ext               :  default,url-select"           >> /home/$username/.Xresources
echo "URxvt.keysym.C-i             :  perl:url-select:select_next"  >> /home/$username/.Xresources
echo "URxvt.keysym.Shift-Control-C :  perl:clipboard:copy"          >> /home/$username/.Xresources
echo "URxvt.keysym.Shift-Control-V :  perl:clipboard:paste"         >> /home/$username/.Xresources
echo "URxvt.clipboard.copycmd      :  xsel -ib"                     >> /home/$username/.Xresources
echo "URxvt.clipboard.copypaste    :  xsel -ob"                     >> /home/$username/.Xresources
echo "URxvt.url-select.launcher    :  /usr/bin/opera"               >> /home/$username/.Xresources
echo "URxvt.url-select.underline   :  true"                         >> /home/$username/.Xresources
echo "URxvt.colorUL                :  #78A4FF"                      >> /home/$username/.Xresources
echo "URxvt.letterSpace            : -1"                            >> /home/$username/.Xresources

# configuration de vim

echo "syntax on" >> /etc/vimrc
echo "set number" >> /etc/vimrc
echo "set tabstop=2" >> /etc/vimrc
echo "set shiftwidth=2" >> /etc/vimrc
echo "set expandtab" >> /etc/vimrc

# EOF
