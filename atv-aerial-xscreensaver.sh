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
DayLosAngelesArray=(
    Los_Angeles/Day/comp_LA_A008_C004_ALTB_ED_FROM_FLAME_RETIME_v46_SDR_PS_20180917_SDR_2K_HEVC.mov
    Los_Angeles/Day/comp_LA_A006_C008_PSNK_ALL_LOGOS_v10_SDR_PS_FINAL_20180801_SDR_2K_HEVC.mov
    Los_Angeles/Day/comp_LA_A005_C009_PSNK_ALT_v09_SDR_PS_201809134_SDR_2K_HEVC.mov
)
DayHongKongArray=(
    Hong_Kong/Day/comp_HK_H004_C010_PSNK_v08_SDR_PS_20181009_SDR_2K_HEVC.mov
    Hong_Kong/Day/HK_H004_C013_2K_SDR_HEVC.mov
    Hong_Kong/Day/comp_HK_H004_C008_PSNK_v19_SDR_PS_20180914_SDR_2K_HEVC.mov
    Hong_Kong/Day/comp_HK_H004_C001_PSNK_DENOISE_v14_SDR_PS_FINAL_20180731_SDR_2K_HEVC.mov
)
DayLiwaArray=(
    Liwa/Day/comp_LW_L001_C003__PSNK_DENOISE_v04_SDR_PS_FINAL_20180803_SDR_2K_HEVC.mov
    Liwa/Day/comp_LW_L001_C006_PSNK_DENOISE_v02_SDR_PS_FINAL_20180709_SDR_2K_HEVC.mov
)
DayGreenlandArray=(
    Greenland/Day/comp_GL_G002_C002_PSNK_v03_SDR_PS_20180925_SDR_2K_HEVC.mov
)
DayHawaiiArray=(
    Hawaii/Clouds/comp_H004_C007_PS_v02_SDR_PS_20180925_SDR_2K_HEVC.mov
    Hawaii/Clouds/comp_H004_C009_PS_v01_SDR_PS_20180925_SDR_2K_HEVC.mov
    Hawaii/Day/comp_H007_C003_PS_v01_SDR_PS_20180925_SDR_2K_HEVC.mov
    Hawaii/Day/comp_H005_C012_PS_v01_SDR_PS_20180925_SDR_2K_HEVC.mov
)
DayLondonArray=(
    London/Day/comp_L010_C006_PS_v01_SDR_PS_20180925_SDR_2K_HEVC.mov
    London/Day/comp_L007_C007_PS_v01_SDR_PS_20180925_SDR_2K_HEVC.mov
)
DayDubayArray=(
    Dubai/Day/comp_DB_D008_C010_PSNK_v21_SDR_PS_20180914_F0F16157_SDR_2K_HEVC.mov
    Dubai/Day/comp_DB_D002_C003_PSNK_v04_SDR_PS_20180914_SDR_2K_HEVC.mov
    Dubai/Day/comp_DB_D001_C001_PSNK_v06_SDR_PS_20180824_SDR_2K_HEVC.mov
    Dubai/Day/comp_DB_D001_C005_COMP_PSNK_v12_SDR_PS_20180912_SDR_2K_HEVC.mov
)
DayChinaArray=(
    China/Day/comp_C004_C003_PS_v01_SDR_PS_20180925_SDR_2K_HEVC.mov
    China/Day/comp_C001_C005_PS_v01_SDR_PS_20180925_SDR_2K_HEVC.mov
    China/Day/comp_CH_C002_C005_PSNK_v05_SDR_PS_FINAL_20180709_SDR_2K_HEVC.mov
    China/Day/comp_CH_C007_C004_PSNK_v02_SDR_PS_FINAL_20180709_SDR_2K_HEVC.mov
    China/Day/comp_CH_C007_C011_PSNK_v02_SDR_PS_FINAL_20180709_SDR_2K_HEVC.mov
    China/Day/comp_C003_C003_PS_v01_SDR_PS_20180925_SDR_2K_HEVC.mov
)
DayNewYorkArray=(
    New_York/Day/comp_N008_C009_PS_v01_SDR_PS_20180925_SDR_2K_HEVC.mov
    New_York/Day/comp_N003_C006_PS_v01_SDR_PS_20180925_SDR_2K_HEVC.mov
)
DaySanFranciscoArray=(
    San_Francisco/Day/comp_A008_C007_011550_CC_v01_SDR_PS_FINAL_20180709_SDR_2K_HEVC.mov
    San_Francisco/Day/comp_A013_C012_0122D6_CC_v01_SDR_PS_FINAL_20180709_SDR_2K_HEVC.mov
    San_Francisco/Day/comp_A006_C003_1219EE_CC_v01_SDR_PS_FINAL_20180709_SDR_2K_HEVC.mov
)
NightLosAngelesArray=(
    Los_Angeles/Night/comp_LA_A006_C004_v01_SDR_FINAL_PS_20180730_SDR_2K_HEVC.mov
    Los_Angeles/Night/comp_LA_A011_C003_DGRN_LNFIX_STAB_v57_SDR_PS_20181002_SDR_2K_HEVC.mov
    Los_Angeles/Night/comp_LA_A009_C009_PSNK_v02_SDR_PS_FINAL_20180709_SDR_2K_HEVC.mov
    Los_Angeles/Night/LA_A011_C003_2K_SDR_HEVC.mov
)
NightHongKongArray=(
    Hong_Kong/Night/comp_HK_B005_C011_PSNK_v16_SDR_PS_20180914_SDR_2K_HEVC.mov
)
NightGreenlandArray=(
    Greenland/Night/comp_GL_G004_C010_PSNK_v04_SDR_PS_FINAL_20180709_SDR_2K_HEVC.mov
    Greenland/Night/comp_GL_G010_C006_PSNK_NOSUN_v12_SDR_PS_FINAL_20180709_SDR_2K_HEVC.mov
)
NightHawaiiArray=(
    Hawaii/Night/comp_H012_C009_PS_v01_SDR_PS_20180925_SDR_2K_HEVC.mov
)
NightLondonArray=(
    London/Night/comp_L012_c002_PS_v01_SDR_PS_20180925_SDR_2K_HEVC.mov
    London/Night/comp_L004_C011_PS_v01_SDR_PS_20180925_SDR_2K_HEVC.mov
)
NightDubaiArray=(
    Dubai/Night/comp_DB_D011_C010_PSNK_DENOISE_v19_SDR_PS_20180914_SDR_2K_HEVC.mov
    Dubai/Night/DB_D011_C009_2K_SDR_HEVC.mov
)
NightNewYorkArray=(
    New_York/Night/comp_N013_C004_PS_v01_SDR_PS_20180925_F1970F7193_SDR_2K_HEVC.mov
    New_York/Night/comp_N008_C003_PS_v01_SDR_PS_20180925_SDR_2K_HEVC.mov
)
NightSanFranciscoArray=(
    San_Francisco/Night/comp_A007_C017_01156B_v02_SDR_PS_20180925_SDR_2K_HEVC.mov
    San_Francisco/Night/comp_1223LV_FLARE_v21_SDR_PS_FINAL_20180709_F0F5700_SDR_2K_HEVC.mov
    San_Francisco/Night/comp_A012_C014_1223PT_v53_SDR_PS_FINAL_20180709_F0F8700_SDR_2K_HEVC.mov
    San_Francisco/Night/comp_A015_C018_0128ZS_v03_SDR_PS_FINAL_20180709__SDR_2K_HEVC.mov
)
SpaceArray=(
    Africa_and_the_Middle_East/Space/comp_A103_C002_0205DG_v12_SDR_FINAL_20180706_SDR_2K_HEVC.mov
    Korean_and_Japan_Night/Space/comp_GMT026_363A_103NC_E1027_KOREA_JAPAN_NIGHT_v18_SDR_PS_20180907_SDR_2K_HEVC.mov
    New_Zealand/Space/comp_A105_C003_0212CT_FLARE_v10_SDR_PS_FINAL_20180711_SDR_2K_HEVC.mov
    Sahara_and_Italy/Space/comp_A009_C001_010181A_v09_SDR_PS_FINAL_20180725_SDR_2K_HEVC.mov
    California_to_Vegas/Space/comp_GMT306_139NC_139J_3066_CALI_TO_VEGAS_v08_SDR_PS_20180824_SDR_2K_HEVC.mov
    Antarctica/Space/comp_GMT110_112NC_364D_1054_AURORA_ANTARTICA__COMP_FINAL_v34_PS_SDR_20181107_SDR_2K_HEVC.mov
    West_Africa_to_the_Alps/Space/comp_A001_C004_1207W5_v23_SDR_FINAL_20180706_SDR_2K_HEVC.mov
    Iran_and_Afghanistan/Space/comp_A083_C002_1130KZ_v04_SDR_PS_FINAL_20180725_SDR_2K_HEVC.mov
    Italy_to_Asia/Space/comp_GMT329_113NC_396B_1105_ITALY_v03_SDR_FINAL_20180706_SDR_2K_HEVC.mov
    Ireland_to_Asia/Space/comp_GMT329_117NC_401C_1037_IRELAND_TO_ASIA_v48_SDR_PS_FINAL_20180725_F0F6300_SDR_2K_HEVC.mov
    China/Space/comp_GMT329_113NC_396B_1105_CHINA_v04_SDR_FINAL_20180706_F900F2700_SDR_2K_HEVC.mov
    Africa/Space/comp_GMT312_162NC_139M_1041_AFRICA_NIGHT_v14_SDR_FINAL_20180706_SDR_2K_HEVC.mov
    North_America_Aurora/Space/comp_GMT314_139M_170NC_NORTH_AMERICA_AURORA__COMP_v22_SDR_20181206_v12CC_SDR_2K_HEVC.mov
    New_York/Space/comp_GMT307_136NC_134K_8277_NY_NIGHT_01_v25_SDR_PS_20180907_SDR_2K_HEVC.mov
    Southern_California_to_Baja/Space/comp_A114_C001_0305OT_v10_SDR_FINAL_22062018_SDR_2K_HEVC.mov
    Caribbean/Space/comp_GMT308_139K_142NC_CARIBBEAN_DAY_v09_SDR_FINAL_22062018_SDR_2K_HEVC.mov
    Caribbean/Space/comp_A108_C001_v09_SDR_FINAL_22062018_SDR_2K_HEVC.mov
)
JellyfishArray=(
    Underseas/Jellyfish/g201_AK_A003_C014_SDR_20191113_SDR_2K_HEVC.mov
    Underseas/Jellyfish/PA_A010_C007_SDR_20190717_SDR_2K_HEVC.mov
    Underseas/Jellyfish/PA_A001_C007_SDR_20190717_SDR_2K_HEVC.mov
    Underseas/Jellyfish/PA_A002_C009_SDR_20190730_ALT01_SDR_2K_HEVC.mov
    Underseas/Jellyfish/AK_A004_C012_SDR_20191217_SDR_2K_HEVC.mov
)
FishAndMammalsArray=(
    Underseas/Fish_and_Mammals/g201_WH_D004_L014_SDR_20191031_SDR_2K_HEVC.mov
    Underseas/Fish_and_Mammals/SE_A016_C009_SDR_20190717_SDR_2K_HEVC.mov
    Underseas/Fish_and_Mammals/CR_A009_C007_SDR_20191113_SDR_2K_HEVC.mov
    Underseas/Fish_and_Mammals/BO_A018_C029_SDR_20190812_SDR_2K_HEVC.mov
    Underseas/Fish_and_Mammals/BO_A014_C008_SDR_20190719_SDR_2K_HEVC.mov
    Underseas/Fish_and_Mammals/FK_U009_C004_SDR_20191220_SDR_2K_HEVC.mov
    Underseas/Fish_and_Mammals/DL_B002_C011_SDR_20191122_SDR_2K_HEVC.mov
    Underseas/Fish_and_Mammals/MEX_A006_C008_SDR_20190923_SDR_2K_HEVC.mov
    Underseas/Fish_and_Mammals/BO_A014_C023_SDR_20190717_F240F3709_SDR_2K_HEVC.mov
)
UnderseasOtherArray=(
    Underseas/Other/g201_TH_804_A001_8_SDR_20191031_SDR_2K_HEVC.mov
    Underseas/Other/g201_TH_803_A001_8_SDR_20191031_SDR_2K_HEVC.mov
    Underseas/Other/BO_A012_C031_SDR_20190726_SDR_2K_HEVC.mov
)
PlantsArray=(
    Underseas/Plants/g201_CA_A016_C002_SDR_20191114_SDR_2K_HEVC.mov
    Underseas/Plants/KP_A010_C002_SDR_20190717_SDR_2K_HEVC.mov
)
CoralsArray=(
    Underseas/Corals/PA_A004_C003_SDR_20190719_SDR_2K_HEVC.mov
    Underseas/Corals/RS_A008_C010_SDR_20191218_SDR_2K_HEVC.mov
)

# Pick the videos you want
DayArray=(
    "${DayLosAngelesArray[@]}"
    "${DayHongKongArray[@]}"
    "${DayLiwaArray[@]}"
    "${DayGreenlandArray[@]}"
    "${DayHawaiiArray[@]}"
    "${DayLondonArray[@]}"
    "${DayDubayArray[@]}"
    "${DayChinaArray[@]}"
    "${DayNewYorkArray[@]}"
    "${DaySanFranciscoArray[@]}"
)
NightArray=(
    "${NightLosAngelesArray[@]}"
    "${NightHongKongArray[@]}"
    "${NightGreenlandArray[@]}"
    "${NightHawaiiArray[@]}"
    "${NightLondonArray[@]}"
    "${NightDubaiArray[@]}"
    "${NightNewYorkArray[@]}"
    "${NightSanFranciscoArray[@]}"
)
UnderseasArray=(
    "${JellyfishArray[@]}"
    "${FishAndMammalsArray[@]}"
    "${UnderseasOtherArray[@]}"
    "${PlantsArray[@]}"
    "${CoralsArray[@]}"
)

others=(
    "${UnderseasArray[@]}"
    "${SpaceArray[@]}"
)
night=(
    "${NightArray[@]}"
    "${others[@]}"
)
day=(
    "${DayArray[@]}"
    "${others[@]}"
)

buildlist() {
    day_length=$(wc -l "$day_db" | awk '{ print $1 }')
    if [[ $day_length -lt 2 ]]; then
        echo "${day[@]}" | sed 's/ /\n/g' > $day_db
    fi
    night_length=$(wc -l "$night_db" | awk '{ print $1 }')
    if [[ $night_length -lt 2 ]]; then
        echo "${night[@]}" | sed 's/ /\n/g' > $night_db
    fi
}

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