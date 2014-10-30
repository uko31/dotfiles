#!/bin/bash
#
# 2014-10-19
#
# m dot gregoriades at gmail dot com
#
# Ce script est rappatrié via git
# git@github.com/uko31/dotfiles
# il permet la mise à jour de l'environnement de travail normalisé de mes postes
# il est lancé après l'installation du core linux

function network_setup {
  # default values
  local cfg_dir=/etc/netctl
  local cfg_file=home
  local ip=192.168.1.5
  local iface=enp3s0
   
  while getopts "f:a:i:" o
  do
    case $o in
     'f' ) cfg_file=${OPTARG} ;;
     'a' ) ip=${OPTARG} ;;
     'i' ) iface=${OPTARG} ;;
    esac
  done
   
  echo <<< EOL
  CONNECTION='ethernet'
  DESCRIPTION='My network setup @$cfg_file'
  INTERFACE=$iface
  IP='static'
  ADDR=('$ip/24')
  GATEWAY='192.168.1.1'"
  DNS=('8.8.8.8' '8.8.4.4')
  EOL > $cfg_dir/$cfg_file
   
  cat $cfg_dir/$cfg_file
  systemctl enable $cfg_file
   
  return 0
}

function setup_fstab {
  local fstab_file="/etc/fstab"
  
  echo "sauvegarde du fichier origine:"
  cp "$fstab_file" "$fstab_file.origin"

  

  return 0
}

# - - - - - - Main Program - - - - - - #
setup_network
