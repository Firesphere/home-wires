import json
import os
import subprocess

import requests


def convert(seconds):
    hours = seconds // 3600
    seconds %= 3600
    mins = seconds // 60
    seconds %= 60
    return hours, mins, seconds


def find(name):
    rootpath = '../'
    for root, dirs, files in os.walk(rootpath):
        for file in files:
            if file.startswith(name) and not file.endswith('.srt'):
                return os.path.join(root, file)


def download(url, name, video):
    name = name.replace(' ', '_')
    vidpath = '../Videos/{}'.format(name)
    os.makedirs(vidpath, exist_ok=True)
    target = '{}/{}'.format(vidpath, video)
    with requests.get(url, verify=False, stream=True) as downloaded:
        with open(target, 'wb') as outputfile:
            for chunk in downloaded.iter_content(chunk_size=512 * 1024):
                outputfile.write(chunk)
    return target


def generate_captions(location, captions):
    result = subprocess.run(["ffprobe", "-v", "error", "-show_entries",
                             "format=duration", "-of",
                             "default=noprint_wrappers=1:nokey=1", location],
                            stdout=subprocess.PIPE,
                            stderr=subprocess.STDOUT)
    video_duration = float(result.stdout)  # Contains the duration of the video in terms of seconds
    video_duration = round(video_duration)
    captions['timedCaptions'][str(video_duration)] = ''
    tmp = {}
    for time, caption in captions['timedCaptions'].items():
        tmp[int(time)] = caption
    tmp = sorted(tmp)
    i = 1
    srt_string = ''
    prev_time = False
    for time in tmp:
        if prev_time is not False:
            start_time = convert(prev_time)
            end_time = convert(time)
            text = captions['timedCaptions'][str(prev_time)]
            seconds = end_time[2]
            # If the end-time is at 0 seconds, stuff breaks
            minutes = end_time[1]
            if seconds > 0:
                seconds = seconds - 1
            else:
                minutes = minutes - 1
                seconds = 59

            srt_string = "{}{}\n{}:{}:{},000 --> {}:{}:{},999\n{}\n\n".format(
                srt_string,
                i,
                str(start_time[0]).zfill(2),
                str(start_time[1]).zfill(2),
                str(start_time[2]).zfill(2),
                str(end_time[0]).zfill(2),
                str(minutes).zfill(2),
                str(seconds).zfill(2),
                text
            )
            i = i + 1
        if captions['timedCaptions'][str(time)] == '':
            fullpath = location.split('/')
            folder = location.replace(fullpath[-1], '').replace('../Videos/', '')
            os.makedirs(folder, exist_ok=True)
            srt_location = location.replace('../Videos/', '').replace('mov', 'srt')
            open(srt_location, 'w').write(srt_string)
            break

        prev_time = time


if __name__ == "__main__":
    entries = json.load(open('./apple-tv-screensavers.json', 'r'))

    for entry in entries['data']:
        for screensaver in entry['screensavers']:
            file = screensaver['videoURL'].replace('AVC', 'HEVC')
            filename = file.split('/')[-1]
            path = find(filename.replace('.mov', ''))
            if path is None:
                print('Not found: {}: {}'.format(entry['name'], screensaver['videoURL']))

                path = download(screensaver['videoURL'], entry['name'], filename)
            else:
                print('Video {}: {} found, generating captions'.format(entry['name'], path))

            generate_captions(path, screensaver)
