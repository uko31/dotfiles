#!/bin/bash

#==============================================================================
#
# loop through $check_dirs and search file with extensions in $extensions
# for each file:
#   add download to transmission server
#   save torrent file in ~/.config/torrent_cache
#
#==============================================================================

check_dirs=("$HOME/downloads")
extensions=("torrent" "tor")

count=0

for dir in ${check_dirs[@]}; do

  echo
#  echo "<span color='light blue'>checking: <b>$dir</b></span>"
  for ext in ${extensions[@]}; do
#    echo "  checking $dir/*.$ext"

    if [[ "$dir/*.$ext" != "`echo $dir/*.$ext`" ]]; then
      for f in $dir/*.$ext; do
        echo "<span color='light green'>+ $f</span>"
        res = $(transmission-remote nas -a "$f")
        res = $(mv "$f" $HOME/.config/torrent_cache)
        count=$(($count+1))
      done
    fi
  done

  [[ $count == 0 ]] && echo "<span color='orange'>There is no download to add.</span>"

done
