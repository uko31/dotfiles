#!/bin/bash

#==============================================================================
#
# check current downloads with transmission-remote nas -l
# for each download with status:
#  - Seeding
#  or
#  - Idle + progress at 100%
# delete download with transmission-remote nas -t[id] -r
#
#==============================================================================

transmission-remote nas -l | awk '
  NR == 1 {
    status_pos = index($0, "Status")
    count = 0
  }

  /^.[ 0-9]/ {
    go = 0
    split(substr($0, status_pos),status," ")
    if ( status[1] == "Seeding") {
      # printf( "Seeding finished torrent found id: [%d]\n", $1 )
      go = 1
    } else if ( status[1] == "Idle") {
      if ( $2 == "100%" ) {
        # printf( "Idle finished torrent found id: [%d]\n", $1 )
        go = 1
      }
    }

    if ( go == 1 ) {
      count++
      system( sprintf("transmission-remote nas -t%d -r", $0) )
    }
  }

  END{
    if ( count == 0 ) {
      printf("\n<span color=\"orange\">There is no torrent to remove.</span>\n")
    } else {
      printf("\n<span color=\"light green\">[%d] torrent(s) removed</span>\n", count)
    }
  }

'
