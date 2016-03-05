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
alias red='mount ~/usb/red && cd ~/usb/red && ll'
alias key='mount ~/usb/key && cd ~/usb/key && ll'

alias update_misc='~/dat/www/py/parse.py'

alias trr='transmission-remote nas'
alias ltr='trr -l'
alias atr='trr -a'
alias rtr='remove_finished_downloads'
alias slow_transmission='transmission-remote nas -as;echo "Enable Alternate Speed"'
alias speed_transmission='transmission-remote nas -AS;echo "Disable Alternate Speed"'

alias bitrate='ffprobe -v error -show_entries format=bit_rate -print_format default=noprint_wrappers=1:nokey=1'
alias duration='ffprobe -v error -show_entries format=duration -print_format default=noprint_wrappers=1:nokey=1'
alias width='ffprobe -v error -show_entries stream=width -print_format default=noprint_wrappers=1:nokey=1'

alias scr='import -window root'

PS1='[\u@\h \W]\$ '

download() {
    if [[ "`echo /home/mika/downloads/*.torrent`" == "/home/mika/downloads/*.torrent" ]]
    then
        echo "No torrent files pending for download."
    else
        mv -v ~/downloads/*.torrent ~/downloads/.watch
    fi
}

download_remove() {
    transmission-remote -n mika:*** -t $1 -r
}

backup_miscdb() {

    sqlite3 ~/dat/www/misc/dat/miscdb ".dump RawData" > ~/dat/www/misc/dat/rawdata.sql
    sqlite3 ~/dat/www/misc/dat/miscdb ".dump ClipName" > ~/dat/www/misc/dat/clipname.sql
    sqlite3 ~/dat/www/misc/dat/miscdb ".dump Names" > ~/dat/www/misc/dat/names.sql

}

adjust() {
    ffmpeg -i "$1" -strict -2 -ss $2 "../$3"
}

# remove all finished downloads
remove_finished_downloads() {
  ltr | awk '
    NR == 1 {
      status_pos = index($0, "Status")
      count = 0
    }
    /^.[ 0-9]/ {
      go = 0
      split(substr($0, status_pos),status," ")
      if ( status[1] == "Seeding")
        printf( "Seeding finished torrent found id: [%d]\n", $1 )
        go = 1
      if ( status[1] == "Idle")
        if ( $2 == "100%" )
          printf( "Idle finished torrent found id: [%d]\n", $1 )
          go = 1

      if ( go == 1 )
        count++
        system( sprintf("transmission-remote nas -t%d -r", $0) )
    }
    END{
      if ( count == 0 )
        printf("No torrent removed\n")
      else
        printf("[%d] torrent(s) removed\n", count)
    }
  '
}
