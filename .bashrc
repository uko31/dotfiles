#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias l='ls --color=auto'
alias ll='l -lh'
alias la='l -lha'

alias vi='vim'

alias m='mplayer'
alias mp='mplayer -loop 0 -playlist'

alias dat='if [[ $(mount | grep ~/dat | wc -l) == 0 ]]; then mount ~/dat; fi && cd ~/dat && ll'
alias nas='if [[ $(mount | grep ~/nas | wc -l) == 0 ]]; then mount ~/nas; fi && cd ~/nas && ll'

alias update_misc='~/dat/www/py/parse.py'

alias tr='transmission-remote nas'
alias lt='tr -l'
alias slow_transmission='tr -as; echo "Enable Alternate Speed"'
alias speed_transmission='tr -AS; echo "Disable Alternate Speed"'

alias bitrate='ffprobe -v error -show_entries format=bit_rate -print_format default=noprint_wrappers=1:nokey=1'
alias duration='ffprobe -v error -show_entries format=duration -print_format default=noprint_wrappers=1:nokey=1'
alias width='ffprobe -v error -show_entries stream=width -print_format default=noprint_wrappers=1:nokey=1'

PS1='[\u@\h \W]\$ '

backup_miscdb() {

    sqlite3 ~/dat/www/misc/dat/miscdb ".dump RawData" > ~/dat/www/misc/dat/rawdata.sql
    sqlite3 ~/dat/www/misc/dat/miscdb ".dump ClipName" > ~/dat/www/misc/dat/clipname.sql
    sqlite3 ~/dat/www/misc/dat/miscdb ".dump Names" > ~/dat/www/misc/dat/names.sql

}

adjust() {
    ffmpeg -i "$1" -strict -2 -ss $2 "../$3"
}

