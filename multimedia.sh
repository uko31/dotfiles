#! /bin/bash
#
#  Multimedia set of functions
#    mp4() => convert $input to mp4 using ffmpeg
#    list() => create a list and concat video files into a bigger one
#      this one can be named in a more accurate way
#
# m.gregoriades@gmail.com

function mp4 {
   
   input="$1";
   ext=${input##*.}
   output=${input##*/}".mp4"
   options=""

   shift
   while [[ $1 ]]
   do
      case $1 in
         "-ss" )
            options="$options -ss $2"
            shift
            ;;
         "-t" )
            options="$options -t $2"
            shift
            ;;
      esac
      shift
   done
   
   ffmpeg -i "$input" -strict -2 $options "$output"
   
   return 0
   
}

function list {

  [ "$1" ] || return 1
  if [ "$2" ];
    then
      dest="$2"
    else
      dest="$1"
  fi
  echo "building list file for [$1] in file 'list $1'"
  printf "file '%s'\n" "$1"* > "list $1"
  cat "list $1"
  ffmpeg -f concat -i "list $1" -codec copy "$dest.mp4"
  rm "list $1"
  
  return 0

}

export function mp4
export function list
