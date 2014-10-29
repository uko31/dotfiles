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
  sed -e "s///g" -e "s///g" $sample_configuration_file > $configuration_file
  grep -v "^#" $configuration_file
   
  echo "activation de la configuration réseau:"
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
