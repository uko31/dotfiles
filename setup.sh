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

function setup_network {
  local ip_id="5"
  local hostname="cube"
  local ip_subnet="24"
  local configuration_file="/etc/netctl/home"
  local sample_configuration_file="/etc/netctl/example/ethernet-static"

  echo "=> create network configuration file $configuration_file:"
  sed -e "s/A basic static ethernet connection using iproute/DESCRIPTION=My home connection/g" \
      -e "s/enp2s0/enp3s0/g" \
      -e "s/ADDR='192.168.0.200'/ADDR=('192.168.0.$ip_id\/$ip_subnet')/g" \
      -e "s/GATEWAY='192.168.0.1'/GATEWAY='192.168.1.1'/g" \
      -e "s/DNS=('192.168.0.1')/DNS=('8.8.8.8' '8.8.4.4')/g" \
      $sample_configuration_file > .$configuration_file  
  grep -v "^#" $configuration_file
   
  echo "=> activation de la configuration réseau:"
  systemctl enable ${configuration_file%%/*}
   
  echo "=> mis à jour du hostname:"
  echo $hostname > /etc/hostname
  echo "=> <sauvegarde du fichier /etc/hosts origine:"
  cp /etc/hosts /etc/hosts.origin
  echo "=> mise à jour du fichier /etc/hosts:"
  echo "$addr  $hostname" >> /etc/hosts
  grep -v "^#" /etc/hosts
  
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
