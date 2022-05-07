#!/bin/bash
# Download all videos I know of

BASEURL="http://sylvan.apple.com/Aerials/2x/Videos/"
BASEDIR="$HOME/.local/apple-aerial"

download() {
  name="$1"
  output_dir="$BASEDIR/$2"
  url="$BASEURL/$name"
  mkdir -p "$output_dir"
  output_file="$output_dir/$name"

  if [ ! -f "$output_file" ]; then
    echo "Downloading video from $url"
    wget --no-check-certificate "$url" -O "$output_file" || rm "$output_file"
  fi
}


file="videos.txt"

while read -r item; 
do
    filename=`basename "$item"`
    pathname=`dirname "$item"`
    download "$filename" "$pathname"
done <$file