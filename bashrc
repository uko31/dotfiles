#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -lh'
alias pc='sudo pacman'
alias tl='transmission-remote nas -l'
alias fat='mnt fat'
alias kgb='mnt kgb'
alias pif='mnt pif'
alias nas='mnt nas'

PS1='[\u@\h \W]\$ '

source $HOME/.src/env.sh
source $HOME/.src/utility.sh
source $HOME/.src/multimedia.sh

# end of shell
