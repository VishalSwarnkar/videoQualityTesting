#!/bin/bash

if [ $# -ne 2 ]
then
  echo "Please pass 2 video paths"
  exit 1
fi

if [[ ! -e /results ]]; then
  mkdir results/video0
  mkdir results/video1
fi


video_count=`expr $#`
frame_count=122 || ls *.mp4 | sed -e 's/.*\.//' | uniq -c | awk {'print $1'}

# command to merge all the images to form video
# $ffmpeg -y -start_number 0 -i "image%01d.png" -c:v libx264 -r 24.97 -pix_fmt yuv420p videos/media01.mp4

# get all the frames from the videos, for POC frame rate is 1, if you remove frame rate it will get all the frames
for videos in "$@"; do
  video_count=$((video_count-1))
  echo $((video_count))
  totalFrameFromVod01=$(ffmpeg -i "$videos" -vcodec copy -acodec copy -f null /dev/null 2>&1 | grep -oP 'frame=(\s?)*\d+' | tail -1 | sed 's/[^0-9]*//g')

  echo "Total frame from video 01: $totalFrameFromVod01"

  #$(ffmpeg -i "$videos" -vf "drawtext=fontfile=/usr/share/fonts/TTF/Vera.ttf: text='%{pts\:hms}': x=(w-tw)/2: y=h-(2*lh): fontcolor=white: box=1: boxcolor=0x00000000@1" ./results/video$((video_count))/image%03d.png)

  $(ffprobe -f lavfi -i "movie=$videos" -show_frames -show_entries frame=pkt_pts_time -of csv=p=0 > results/frames-$((video_count)).txt)
done

$(ffmpeg -i $VIDEO1 -i $VIDEO2 -lavfi  psnr="stats_file=results/psnr.log" -f null -)

echo "Difference in the frames is there is any: "
diff -u $PWD/results/frames-0.txt $PWD/results/frames-1.txt
# for value in $(seq 1 $frame_count);
# do
#   $(ffmpeg -i results/video0/image"$value".png -i results/video1/image"$value".png -lavfi  psnr="stats_file=results/psnr-$value.log" -f null -)
# done
