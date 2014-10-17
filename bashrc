#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -lh'
alias pc='sudo pacman'
alias tl='transmission-remote nas -l'

PS1='[\u@\h \W]\$ '

source $HOME/.sources/multimedia.sh

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

