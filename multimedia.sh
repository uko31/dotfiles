#! /bin/bash
#
#  Multimedia set of functions
#    mp4() => convert $input to mp4 using ffmpeg
#    concat() => create a list and concat video files into a bigger one using ffmpeg
#
# m.gregoriades@gmail.com

# mp4 function assumes at least one arg
#   the first one is the name of the media file to be converted in mp4 format
#   the next arguments are ffmpeg options to be added between [input] and [output]
function mp4 {
   local input ext output
   local options=""
   
   input="$1";
   output="${input##*/}.mp4"

   shift
   [[ $* ]] && otpions="$*"

   ffmpeg -i "$input" -strict -2 $options "$output"
   
   return 0
}

# concat function assumes one or two arg
#   the first one is the pattern use to select the files to be concatenated
#   the second one is the output filename (minus the extension which is always mp4)
#     if no 2nd arg is provided, the pattern becomes the filename
function concat {
  local pattern 
  local dest

  [[ $1 ]] || { echo "This function requires an argument => exiting..."; return 1; }
  pattern="$1"
  if [[ $2 ]]
  then
    dest="$2"
  else
    dest="$pattern"
  fi
  echo "building list file for [$pattern] in file 'list-$pattern'"
  printf "file '%s'\n" "$pattern"* > "list-$pattern"
  cat "list-$pattern"
  ffmpeg -f concat -i "list-$pattern" -codec copy "$dest.mp4"
  rm "list-$pattern"
  
  return 0
}

export function mp4
export function concat
