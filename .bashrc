#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -lh'
alias pacman='sudo pacman'
alias tran='transmission-remote nas -l'

PS1='[\u@\h \W]\$ '

function mp4 {
   input=$1;
   ext=${input##*.}
   output=$(basename "$input" .$ext)".mp4"

   ffmpeg -i "$input" -strict -2 "$output"
}
export function mp4

function list {

  [ "$1" ] || return 1
  if [ "$2" ];
    then
      dest="$2"
    else
      dest="$1"
  fi
  echo "building list file for [$1] in file 'list $1'"
  printf "file '%s'\n" "$1"* > "list $1"
  cat "list $1"
  ffmpeg -f concat -i "list $1" -codec copy "$dest.mp4"
  rm "list $1"
  
  return 0

}
export function list

function dl {
   downloads="$HOME/dl"
   nas="$HOME/nas"
   dst=$nas/downloads

   [ -d  "$dst" ] || { echo "Destination directory: [$dst] doesn't exist => exit"; return 1; }

   if [ $1 ]
   then
      [ $DEBUG ] && echo "Debug: there is arg 1: [$1]"
      [ -f $1 -o -f $downloads/$1 ] || { echo "Error: file [$1] doesn't exist => exit"; return 2; }
      [ $DEBUG ] && echo "Debug: file [$1] exists"
      [ -f $1 ] && src=$1
      [ -f $downloads/$1 ] && src=$downloads/$1
      mv -v $src $dst

   else
      [ $DEBUG ] && echo "Debug: no arg passed"
      src=$downloads/*.torrent
      [ "$(echo $src)" != "$src" ] || { echo "Info: No torrent files to download from [$downloads] => exit"; return 3; }
      nb=$(ls $src | wc -l | tr -d ' ')
      [ $DEBUG ] && echo "Debug: torrent files found in [$downloads]"
      mv -v $src $dst
      echo "=> $nb file(s) sent for download"
   fi
   return 0
}
export function dl

