#!/bin/bash
#
# utility script
#
# m.gregoriades@gmail.com

function log {
  type="$1"
  message="$2"
  
  [[ $type ]] || { echo "no type=> aborting..."; return 1; }
  [[ $message ]] || { echo "no message=> aborting..."; return 1; }
  
  [[ $LOG ]] && echo "$(date +%Y-%m-%d %H:%M:%S) $type $message" > $LOG
  [[ $LOG ]] || echo "$(date +%Y-%m-%d %H:%M:%S) $type $message"
  
  return 0
}

function process_dir {
  return 0
}

function process_file {
  return 0
}
