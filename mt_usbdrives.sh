#!/bin/bash

#==============================================================================
#
# this script checks for unmounted drives of type vfat or ext4 in (lsblk -f)
# if there is such drive:
# for each one 
#   it gets its UUID
#   it checks that it exists in /etc/fstab
#   it checks that the mount destination exists and if not
#     try to create it
#   then mount the drive or skip to the next one if any condition is false.
#
#==============================================================================

IFS=$'\n'

count=0

for l in $(lsblk -f); do
  [[ $(echo $l | egrep "(vfat|ext4)") ]] || continue
  uuid=$(echo $l | awk '
  BEGIN { uuid = "" }
  $2 ~ /(vfat|ext4)/ {
    if ( index($4, "/") == 0 && index($5, "/") == 0 ) {
    # printf("Found umount drive\n")
      if ( index($3, "-") ) {
        if ( $2 == "vfat" && length($3) == 9 ) {
          # printf("  UUID: [%s]\n", $3)
          uuid=$3
        }
        if ( $2 == "ext4" && length($3) == 36 ) {
          # printf("  UUID: [%s]\n", $3)
          uuid=$3
        }
      }
      if ( index($4, "-") ) {
        if ( $2 == "vfat" && length($4) == 9 ) {
          # printf("  UUID: [%s]\n", $4)
          uuid=$4
        }
        if ( $2 == "ext4" && length($4) == 36 ) {
          # printf("  UUID: [%s]\n", $4)
          uuid=$4
        }
      }
    } 
  }
  END { print uuid }')

  [[ $uuid ]] || continue

  mpoint=$(grep "$uuid" /etc/fstab | awk '{ print $2 }')

  if [[ $mpoint ]]; then
    if [[ -d $mpoint ]]; then
      printf "\nMounting <b><span color='light green'>[$mpoint]</span></b>\n"
      mount $mpoint
      count=$(($count+1))
      continue
    else
      printf "\n<span color='light blue'>Trying to create [$mpoint]</span>"
      mkdir -p "$mpoint"
      if [[ -d $mpoint ]]; then
        printf " <span color='light blue'>(create successful)</span>"
        printf "\nMounting <b><span color='light green'>[$mpoint]</span></b>\n"
        mount $mpoint
        count=$(($count+1))
        continue
      else
        printf " <span color='red'>( create failed) => skipping</span>\n"
        continue
      fi
    fi
  else
    printf "\n<span color='red'>UUID [$uuid] not in /etc/fstab => skipping</span>\n"
    count=$((count+1))
    continue
  fi

done

[[ $count == 0 ]] && printf "\n<b><span color='orange'>No drive to mount</span></b>\n"

