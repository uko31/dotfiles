#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -lh'
alias pc='sudo pacman'
alias tn='transmission-remote nas -l'
alias nas='mnt nas'
alias dat='mnt dat'
alias fat='mnt fat'

PS1='[\u@\h \W]\$ '

source ~/.multimedia.sh
source ~/.utility.sh

