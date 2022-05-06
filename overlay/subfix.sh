#!/bin/bash

srts=$(find . -name "*.srt")

for srt in $srts
do
  # nbsp thing
  $(sed -i 's/ / /g' $srt)
  # weird quotes
  $(sed -i "s/‘/'/g" $srt)
  $(sed -i "s/’/'/g" $srt)
  # macrons don't work on subtitles
  $(sed -i "s/ā/a/g" $srt)
done