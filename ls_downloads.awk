#==============================================================================
#
# this function displays a progress bar, % and status
#  the bar is 50 characters width.
#
#==============================================================================
function progress_bar(pct, color) {
  progress="["
  for (i=0; i<99; i+=2) {
    if ( i < int(pct) )
      progress=progress "="
    else
      progress=progress " "
  }
  progress=progress "]"
  progress = sprintf("<span color='%s'>%s</span>", color, progress)
  return progress
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# init color name/code:
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
BEGIN {
   idle_color     = "dark gray"
   download_color = "light blue"
   sedding_color  = "light green"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# First line, grabbing index position for status and torrent name
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
NR == 1 {
  status_pos    = index($0, "Status")
  name_pos      = index($0, "Name")
  #download_info = ""
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# lines beginning with spaces+digit are downloads:
#  getting status, name, id and progress
#  based on status & progress:
#     assign color & custom status
#     append formatted output to download_info
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
/^[ 0-9]/ {
  status = substr($0, status_pos)
  name   = substr($0, name_pos)
  id     = $1
  pct    = substr($2, 1, length($2)-1)

  if ( match(status, "Up & Down") != 0 ) {
    status = "Downloading"
    color  = download_color
  }
  else  if ( match(status, "Downloading") != 0 ) {
    status = "Downloading"
    color  = download_color
  }
  else if ( match(status, "Seeding") != 0 ) {
    status = "Seeding"
    color  = sedding_color
  }
  else if ( match(status, "Idle") != 0 ) {
    if ( int(pct) == 100 ) {
      status = "Seeding"
      color  = sedding_color
    }
  } else {
      status = "Queued"
      color  = idle_color
  }
  
  download_info = sprintf( "%s%d: %s\n", download_info, id, name )
  download_info = sprintf( "%s<span color='%s'>%s %s%% (%s)</span>\n", 
                           download_info, 
                           color, 
                           progress_bar(pct, color), 
                           pct, 
                           status )
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# line beginning with Sum: is the last one, it gives infos on the up/down 
# net usage.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
/^Sum:/ {
  dn = $5
  up = $4
  speed = sprintf("%skb/%skb", dn, up)
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# post processing:
#  if no download => display message
#  if download(s) => display download informations
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
END {
  download_tasks = NR-2

  if ( download_tasks == 0 )
    printf("\n<span color='orange'>There is no download at the moment.</span>\n")
  else
    printf( "\n<b><span color='light gray'>%d download task(s) pending</span></b>: (%s)\n", 
            download_tasks, 
            speed )

  if ( download_info )
    printf("\n%s\n", download_info)

  exit
}
