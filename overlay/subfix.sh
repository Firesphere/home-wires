#!/bin/bash

srts=$(find . -name "*.srt")

for srt in $srts
do
  $(sed -i 's/>>>>/>/g' $srt)
  $(sed -i 's/ / /g' $srt)
  $(sed -i "s/‘/'/g" $srt)
  $(sed -i "s/ā/a/g" $srt)
done