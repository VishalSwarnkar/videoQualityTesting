FROM ubuntu

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN apt-get update && apt-get install ffmpeg -y

command : docker run --rm -w '/usr/src/app' -v ~/Documents/MyBackup/Innovation/MydockVideoTesting/videos/:/usr/src/app/videos -v ~/Documents/MyBackup/Innovation/MydockVideoTesting/ffmpeg_exp/results/:/usr/src/app/results -v ~/Documents/MyBackup/Innovation/MydockVideoTesting/ffmpeg_exp/:/usr/src/app/ -it swarnkardocker/ffmpeg /bin/bash

# extract all the frames from the video:
ffmpeg -i "videos/sample-video.mp4" -t 300 -vf select="eq(pict_type\,PICT_TYPE_I)" -vsync 2 -s 160x90 -f image2 results/thumbnails-%02d.jpeg -loglevel debug 2>&1| for /f "tokens=4,8,9 delims=. " %d in ('findstr "pict_type:I"') do echo %d %e.%f>>"keyframe_list.txt"

ffmpeg -i "videos/sample-video.mp4" -t 5 -vf select="eq(pict_type\,PICT_TYPE_I)" -vsync 2 -s 160x90 -f image2 results/thumbnails-%02d.jpeg -loglevel debug 2>&1| >> results/key.txt

# psnr calculation
ffmpeg -i videos/sample-video.mp4 -i videos/sample-video02.mp4 -lavfi  psnr="stats_file=results/psnr.log" -f null -

# command to generate UI difference between images/frames
https://stackoverflow.com/questions/25774996/how-to-compare-show-the-difference-between-2-videos-in-ffmpeg

cat logfile | grep -oP 'frame=\d+' | tail -1 | sed 's/[^0-9]*//g'

# Extract the all the frames with the time stamp on top of it
ffmpeg -i videos/OriginalVOD_modified.mp4 -vf "drawtext=fontfile=/usr/share/fonts/TTF/Vera.ttf: text='%{pts\:hms}': x=(w-tw)/2: y=h-(2*lh): fontcolor=white: box=1: boxcolor=0x00000000@1" image%03d.png

# Extract the frames based on frame rate
ffmpeg -i input -vf "drawtext=fontfile=/usr/share/fonts/TTF/Vera.ttf: timecode='00\:00\:00\:00': r=25: x=(w-tw)/2: y=h-(2*lh): fontcolor=white: box=1: boxcolor=0x00000000@1" image%03d.png

# Extract every seconds frames
ffmpeg -i videos/OriginalVOD_modified.mp4 -r 1 -t 10 -vf "drawtext=fontfile=/usr/share/fonts/TTF/Vera.ttf: text='%{pts\:hms}': x=(w-tw)/2: y=h-(2*lh): fontcolor=white: box=1: boxcolor=0x00000000@1" image%03d.png
