#!/bin/bash

command -v mplayer >/dev/null 2>&1 || {
  echo "I require mplayer but it's not installed. Aborting." >&2
  exit 1; 
}

[[ -z "$XDG_CONFIG_HOME" ]] &&
  XDG_CONFIG_HOME="$HOME/.config"

# database files to allow for no repeats when playing videos
day_db=$XDG_CONFIG_HOME/.atv4-day
night_db=$XDG_CONFIG_HOME/.atv4-night

# path of movies
# movies=/opt/ATV4
movies="$HOME/.local/apple-aerial"

# Put all relevant files in a variable
NightArray=$(cat "$movies/Night/videos.txt")
DayArray=$(cat "$movies/Day/videos.txt")
SpaceArray=$(cat "$movies/Space/videos.txt")
# The following are all under the sea
JellyfishArray=$(cat "$movies/Jellyfish/videos.txt")
Fish_and_MammalsArray=$(cat "$movies/Fish_and_Mammals/videos.txt")
OtherArray=$(cat "$movies/Other/videos.txt")
PlantsArray=$(cat "$movies/Plants/videos.txt")
CoralsArray=$(cat "$movies/Corals/videos.txt")

buildlist() {
    day_length=$(wc -l "$day_db" | awk '{ print $1 }')
    if [[ $day_length -lt 2 ]]; then
        echo "${DayArray[@]}" | sed 's/ /\n/g' > $day_db
        echo "${SpaceArray[@]}" | sed 's/ /\n/g' >> $day_db
        echo "${JellyfishArray[@]}" | sed 's/ /\n/g' >> $day_db
        echo "${Fish_and_MammalsArray[@]}" | sed 's/ /\n/g' >> $day_db
        echo "${OtherArray[@]}" | sed 's/ /\n/g' >> $day_db
        echo "${PlantsArray[@]}" | sed 's/ /\n/g' >> $day_db
        echo "${CoralsArray[@]}" | sed 's/ /\n/g' >> $day_db
    fi
    night_length=$(wc -l "$night_db" | awk '{ print $1 }')
    if [[ $night_length -lt 2 ]]; then
        echo "${NightArray[@]}" | sed 's/ /\n/g' > $night_db
        echo "${SpaceArray[@]}" | sed 's/ /\n/g' >> $night_db
        echo "${JellyfishArray[@]}" | sed 's/ /\n/g' >> $night_db
        echo "${Fish_and_MammalsArray[@]}" | sed 's/ /\n/g' >> $night_db
        echo "${OtherArray[@]}" | sed 's/ /\n/g' >> $night_db
        echo "${PlantsArray[@]}" | sed 's/ /\n/g' >> $night_db
        echo "${CoralsArray[@]}" | sed 's/ /\n/g' >> $night_db
    fi
}

buildlist

selectVideo() {
    hour=$(date +%H)
    if [ "$hour" -gt 19 -o "$hour" -lt 7 ]; then
        used=$night_db
        unused=$day_db
    else
        used=$day_db
        unused=$night_db
    fi
    length=$(wc -l "$used" | awk '{ print $1 }')
    # two conditions:
    if [[ $length -eq 1 ]]; then
        # 1) 1 line left (one video) so use that video
        pick=1
    elif [[ $length -ge 2 ]]; then
        # 2) 2 or more lines left so select a random number between 1 and length of the list
        pick=$((RANDOM%length+1))
    fi
    selected=$(sed -n "$pick p" "$used")
    # Rebuild the list if needed. We do this after selection
    # So further down, the selected is removed from the newly build list
    buildlist
    
    # Remove the selected video from the "database" files, so we won't repeat
    $(sed -i "s|$selected|""|g" "$used") # Replace with empty string in the used db
    $(sed -i '/^$/d' "$used") # Then, remove all empty lines, to keep the line count correct
    # This will happily do nothing if it's not found, so... yay?
    $(sed -i "s|$selected|""|g" "$unused") # Replace with empty string in the unused db
    $(sed -i '/^$/d' "$unused") # Then, remove all empty lines, to keep the line count correct
}

# Because we put everything in newlines in the buildlist, use newlines as the separator
IFS=$'\n'
# https://github.com/kevincox/xscreensaver-videos
trap : SIGTERM SIGINT SIGHUP
while (true) #!(keystate lshift)
do
  selectVideo
  # Default, use mplayer
  /usr/bin/mplayer -nosound -really-quiet -nolirc -nostop-xscreensaver -wid "$XSCREENSAVER_WINDOW" -fs "$movies/$selected" &
  # Option 2, use MPV
  #/usr/bin/mpv --really-quiet --no-audio --fs --no-stop-screensaver --wid="$XSCREENSAVER_WINDOW" --panscan=1.0 "$movies/$useit" &
  # Option 3, use VLC
  #cvlc --play-and-exit --fullscreen --no-audio --no-osd --drawable-xid "$XSCREENSAVER_WINDOW" "$video" &
  pid=$!
  wait $pid
  [ $? -gt 128 ] && { kill $pid ; exit 128; } ;
done