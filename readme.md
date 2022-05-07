# AppleTV Videos for Linux

This collection of scripts is a combination of:
- https://github.com/kopiro/xscreensaver-apple-aerial/
- https://github.com/graysky2/xscreensaver-aerial

And, my own additions to make it a bit cleaner/easier to read and handle.

I have removed duplicates and/or near-duplicates, as well as grouped all videos in to their respective folders.

The list of videos and their respective locations are in `videos.txt` There are 87 different videos. The 97 mentioned
in other repositories, is commonly a derived version of one of the videos in the list.

# Installation

- Install your player of preference.
  - mplayer: Has caused the least of performance issues
  - mvp: Outdated, but works
  - cvlc: Works, but at times eats up a lot of resources
- Install XScreensaver and it's GL options
  - xscreensaver-gl
- Download the videos, because over the net has proven to be near impossible to properly stream
  - bash download-videos.sh

- Copy or symlink `atv-aerial-xscreensaver.sh` into `/usr/lib/xscreensaver`
- Edit `~/.xscreensaver` and add `GL:   "Apple TV Aerial"  atv-aerial-xscreensaver.sh  \n\` as the first line under `programs:`
- Configure XScreensaver to use Apple TV Aerial
- Probably make the file executable with `chmod a+rx /usr/lib/xscreensaver/atv-aerial-xscreensaver.sh`

## 64bit OS (e.g. Raspberry Pi OS 64bit)

It's pretty much the same, with the exception that the xscreensaver files live in `/usr/libexec/xscreensaver`

# Text overlays

If you like, you can add the name of the file (where available) to your playback, as a subtitle.

For configuration of the subtitle placement and font-size, I suggest you read your player of choice's documentation.

All descriptions are shown for the duration of the file, where possible.

Copy-and-merge the _contents_ (including folders and subfolders), of `overlay` into the same folder of
where your videos are downloaded. So that each video has an `.srt` file next to the video.

The video player should now automatically pick up the subtitle file, and show it for the duration (or the first 5 minutes) of the playback.

# Low-resolution files for Raspberry Pi 7" playback

I'll see if I can/will/shall upload my resized videos to 800*450, some time, some where.


# Pick videos

You can pick videos by theme, by importing specifically those, instead of the full set of `Day` or `Night`
All Day, Night, Space etc. are organised in to flat-file text, so to change the Day list from "all" to "Only Hawaii",
change `Day="$movies/Day/videos.txt"` to e.g. `Hawaii="$movies/Day/Hawaii.txt` and change
```
day_files=(
  $Day
  $Clouds
  etc.
)
```
to
```
day_files=(
  $Hawaii
  $Clouds
  etc.
)
```

If you don't want to split over day and night, put all possibilities in both lists, and it'll work itself out.

# Many thanks

- Apple for making this screensaver idea
- kevincox for the xscreensaver capture
- graysky2 for the original screensaver on which I improved a bit (I think)
- bzamayo for the JSON with the subtitles in readable English

# License

[WTFPL](http://www.wtfpl.net/)