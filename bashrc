#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -lh'
alias pacman='sudo pacman'
alias nas='mnt nas'
alias dat='mnt dat'
alias fat='mnt fat'
alias other='mnt dat && cd .other'

PS1='[\u@\h \W]\$ '

source ~/.multimedia.sh
source ~/.utility.sh

