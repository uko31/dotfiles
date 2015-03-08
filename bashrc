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

alias clone-dot="git clone git@github.com:uko31/dotfiles.git"

source ~/.utility.sh

