#!/bin/bash

folders=$(find . -type d)

IFS=$'\n'
for folder in $folders
do
  len=$(find "$folder" -name "*.mov" | wc -l)
  if [ $len -gt 0 ]
  then
    $(find "$folder" -name "*.mov" > "$folder/videos.txt")
    $(sed -i "s|\./||g" "$folder/videos.txt")
  fi
done

lines=$(cat videos.txt)

for line in $lines
do
  IFS="/" read -ra options <<< "$line"
  name="${options[0]}"
  if [ ! -d ${options[1]} ]; then
    $(mkdir ${options[1]})
  fi
  $(echo $line >> "${options[1]}/$name.txt")
  $(echo $line >> "${options[1]}/videos.txt")
done