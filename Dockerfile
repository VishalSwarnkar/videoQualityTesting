FROM ubuntu

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app
RUN apt-get update && apt-get install ffmpeg -y

CMD /usr/src/app/findMissingFrame.sh $VIDEO1 $VIDEO2

# docker run --rm -w '/usr/src/app' -v $PWD/videos/:/usr/src/app/videos -v $PWD/ffmpeg_exp/results/:/usr/src/app/results -v $PWD/ffmpeg_exp/:/usr/src/app/ -it swarnkardocker/ffmpeg /bin/bash
# docker run --rm -w '/usr/src/app' -v $PWD/ffmpeg_exp/:/usr/src/app/ -it swarnkardocker/ffmpeg
