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
   local dst="$HOME/mnt/nas/downloads"
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

function mnt {
  local root="$HOME/mnt"

  [[ $1 ]] || { echo "no device specified => exiting..."; retun 1; }
  [[ -d $root/$1 ]] || { echo "the device [$root/$1] does not exist => exiting..."; return 2; }
  [[ $(grep "$root/$1" /etc/mtab) ]] || mount "$root/$1"
  [[ $? = 0 ]] || { echo "unable to mount [$root/$1] => exiting..."; return 3; }
  cd "$root/$1"
  ls -lh
  
  return 0
}

function tor {
  local opt arg
  local cmd="transmission-remote nas"

  [[ $1 ]] || opt="None";
  [[ $1 ]] && opt=$1;
  
  case $opt in
    "None" )
      $cmd -l
      ;;
    "r" )
      arg=$2
      $cmd -t $arg -r
      ;;
    "d" )
      if [[ $2 ]]
      then
	arg=$2
	echo "Download limited to $arg kb/s"
	$cmd -d $arg
      else
	arg=$2
	echo "No download limit"
	$cmd -D
      fi
      ;;
    "f" )
      arg=$2
      $cmd -t $arg -f
      ;;
    * )
      echo "tor: transmission home made utility"
      echo "default  => list current torrents"
      echo "'r [id]' => delete or remove [id] torrent"
      echo "'d [id]' => download limit to [id] or unlimited id no [id] provided"
      echo "'f [id]' => list files for [id] torrent"
      ;;
  esac
  
  return 0
}

function process_dir {
  return 0
}

function process_file {
  return 0
}

export function dl
export function mnt
export function tor
# end of shell
