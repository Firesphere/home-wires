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