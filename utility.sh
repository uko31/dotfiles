#!/bin/bash
#
# utility script
#
# m.gregoriades@gmail.com

function log {
  type="$1"
  message="$2"
  
  [[ $type ]] || { echo "no type=> aborting..."; return 1; }
  [[ $message ]] || { echo "no message=> aborting..."; return 1; }
  
  [[ $LOG ]] && echo "$(date +%Y-%m-%d %H:%M:%S) $type $message" > $LOG
  [[ $LOG ]] || echo "$(date +%Y-%m-%d %H:%M:%S) $type $message"
  
  return 0
}

# dl function assumes that a watchdir is set to put .torrent in it.
# dl can either take no arg and put all torrent files found in $HOME/download directory
# or dl can accept one arg per file to be moved.
function dl {
   local downloads="$HOME/dl"
   local dst="$HOME/nas/downloads"
   local src nb

   [[ -d  "$dst" ]] || { echo "Destination directory [$dst] doesn't exist => exiting..."; return 1; }

   if [[ $1 ]]
   then
      [[ -f $1 || -f $downloads/$1 ]] || { echo "File [$1] doesn't exist => exiting..."; return 2; }
      [[ -f $1 ]] && "src=$1"
      [[ -f $downloads/$1 ]] && src="$downloads/$1"
      mv -v "$src" "$dst"
   else
      src=$downloads/*.torrent
      [[ "$(echo $src)" != "$src" ]] || { echo "No torrent files to download from [$downloads] => exiting..."; return 3; }
      nb=$(ls "$src" | wc -l | tr -d ' ')
      mv -v "$src" "$dst"
      echo "  => $nb file(s) sent for download"
   fi
   return 0
}

function usb {
  local root="$HOME/usb"
  local mount=0

  [[ $1 ]] || { echo "no name specified => exiting..."; retun 1; }
  [[ -d $root/$1 ]] || { echo "the device does not exist => exiting..."; return 2; }
  [[ $(mount | grep "$root/$1") ]] && mount=1 
  [[ $mount = 1 ]] || mount "$root/$1"
  [[ $? = 0 ]] || { echo "unable to mount $root/$1 => exiting..."; return 3; }
  cd "$root/$1"
  ls -lh
  
  return 0
}

function process_dir {
  return 0
}

function process_file {
  return 0
}

export function dl
export function usb
# end of shell
