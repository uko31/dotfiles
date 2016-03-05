#!/bin/bash

#==============================================================================
#
# check current downloads with transmission-remote nas -l
# for each download:
#  display the id: name
#  display progress_bar % (status)
# colors are:
#  dark gray   for queued downloads
#  orange      for active downloads
#  light green for finished downloads
#
#==============================================================================

EOF=$'\n'

transmission-remote nas -l | awk '
function progress_bar(pct, color) {
  progress="["
  for (i=0; i<99; i+=2) {
    if ( i < int(pct) )
      progress=progress "="
    else
      progress=progress " "
  }
  progress=progress "]"
  progress = sprintf("<span color=\"%s\">%s</span>", color, progress)
  return progress
}

NR == 1 {
  status_pos    = index($0, "Status")
  name_pos      = index($0, "Name")
  download_info = ""
}

/^[ 0-9]/ {
  status = substr($0, status_pos)
  name   = substr($0, name_pos)
  id     = $1
  pct    = substr($2, 1, length($2)-1)

  if ( match(status, "Up & Down") != 0 ) {
    status = "Downloading"
    color  = "orange"
  }
  else  if ( match(status, "Downloading") != 0 ) {
    status = "Downloading"
    color  = "orange"
  }
  else if ( match(status, "Seeding") != 0 ) {
    status = "Seeding"
    color  = "light green"
  }
  else if ( match(status, "Idle") != 0 ) {
    if ( int(pct) == 100 ) {
      status = "Seeding"
      color  = "light green"
    }
  } else {
      status = "Queued"
      color  = "dark gray"
  }
  
  download_info = sprintf( "%s%d: %s\n", download_info, id, name )
  download_info = sprintf( "%s<span color=\"%s\">%s %s%% (%s)</span>", 
                           download_info, 
                           color, 
                           progress_bar(pct, color), 
                           pct, 
                           status)
}

/^Sum:/ {
  dn = $5
  up = $4
  speed = sprintf("%skb/%skb", dn, up)
}

END {
  download_tasks = NR-2

  if ( download_tasks == 0 )
    printf("\n<span color=\"orange\">There is no download at the moment.</span>\n")
  else
    printf( "\n<b><span color=\"light gray\">%d download task(s) pending</span></b>: (%s)\n", 
            download_tasks, 
            speed )

  if ( download_info )
    printf("\n%s\n", download_info)

  exit
}
'

