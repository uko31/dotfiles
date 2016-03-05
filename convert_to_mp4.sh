#!/bin/bash

cmd="ffmpeg -loglevel error"
ext=("avi" "mkv" "wmv" "mpg" "mpeg")

[[ $1 == "" ]] && echo "usage: ???" && exit 1

input_file=$1
input_ext=${1##*.}
shift
params=$@

if [[ ! "${ext[@]}" =~ "$input_ext" ]];then
  echo "File type {$input_ext} while expecting something like: ${ext[@]}"
  exit 2
fi

output_file=${input_file%.*}.mp4

echo "+ $cmd -i \"$input_file\" -strict -2 $params \"$output_file\""
$cmd -i "$input_file" -strict -2 $params "$output_file"
