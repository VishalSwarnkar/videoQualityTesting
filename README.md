
# Command to execute
docker run --rm -w '/usr/src/app' -v $PWD/ffmpeg_exp/:/usr/src/app/ -e VIDEO1=/usr/src/app/videos/OriginalVOD.mp4 -e VIDEO2=/usr/src/app/videos/MissingFrameVod.mp4 -it videoqualitytesting

## Below are few other commands for reference:

# extract all the frames from the video:
ffmpeg -i "videos/sample-video.mp4" -t 300 -vf select="eq(pict_type\,PICT_TYPE_I)" -vsync 2 -s 160x90 -f image2 results/thumbnails-%02d.jpeg -loglevel debug 2>&1| for /f "tokens=4,8,9 delims=. " %d in ('findstr "pict_type:I"') do echo %d %e.%f>>"keyframe_list.txt"

ffmpeg -i "videos/sample-video.mp4" -t 5 -vf select="eq(pict_type\,PICT_TYPE_I)" -vsync 2 -s 160x90 -f image2 results/thumbnails-%02d.jpeg -loglevel debug 2>&1| >> results/key.txt

# psnr calculation
ffmpeg -i videos/sample-video.mp4 -i videos/sample-video02.mp4 -lavfi  psnr="stats_file=results/psnr.log" -f null -

# command to generate UI difference between images/frames
https://stackoverflow.com/questions/25774996/how-to-compare-show-the-difference-between-2-videos-in-ffmpeg

cat logfile | grep -oP 'frame=\d+' | tail -1 | sed 's/[^0-9]*//g'

# Command to over lay timestamp in the every frames
$ ffmpeg -i videos/OriginalVOD_modified.mp4 -vf "drawtext=fontfile=/usr/share/fonts/TTF/Vera.ttf: text='%{pts\:hms}': x=(w-tw)/2: y=h-(2*lh): fontcolor=white: box=1: boxcolor=0x00000000@1" image%03d.png

# Command to over lay frame numbers in every frames
$ ffmpeg -i videos/OriginalVOD_modified.mp4 -vf "drawtext=fontfile=Arial.ttf: text=%{n}: x=(w-tw)/2: y=h-(2*lh): fontcolor=white: box=1: boxcolor=0x00000099" ./results/video0/image%03d.png

# Extract the frames based on frame rate
$ ffmpeg -i input -vf "drawtext=fontfile=/usr/share/fonts/TTF/Vera.ttf: timecode='00\:00\:00\:00': r=25: x=(w-tw)/2: y=h-(2*lh): fontcolor=white: box=1: boxcolor=0x00000000@1" image%03d.png

# Extract every seconds frames
$ ffmpeg -i videos/OriginalVOD_modified.mp4 -r 1 -t 10 -vf "drawtext=fontfile=/usr/share/fonts/TTF/Vera.ttf: text='%{pts\:hms}': x=(w-tw)/2: y=h-(2*lh): fontcolor=white: box=1: boxcolor=0x00000000@1" image%03d.png

# Extract the duration of the frame in text file
ffprobe -f lavfi -i "movie=OriginalVOD_modified.mp4,fps=fps=25[out0]" -show_frames -show_entries frame=pkt_pts_time -of csv=p=0 > frames.txt

# Sort list of files according to the numbers
ls image-*.png | sort -n -t - -k 2

paste images.txt frames.txt > combined.txt

## Set up tesseract to read the text from give file

$apt-get install imagemagick
$apt-get install tesseract-ocr

$convert results/video0/image001.png results/image001.tif
$tesseract results/image003.tiff output -psm 0
