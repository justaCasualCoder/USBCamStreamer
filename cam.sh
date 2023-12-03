#!/bin/bash
#Arg Parse from https://betterdev.blog/minimal-safe-bash-script-template/
#justaCasualCoder 2023 - https://github.com/justaCasualCoder
#IP=192.168.39.182
IP=$(hostname -I)
RES=1280x720
AUDIO=0
MODE=H264
DEVICE=/dev/video0
UPTIME=1 # Use Uptime kuma
MONITOR=1 # Monitor FFMPEG
NODEVICE=0 # DO NOT CHANGE
MEDIAMTX=1 # Use Mediamtx
KUMAURL=""
usage() {
cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-d] [-a] [-j] [-m] [-r] 1280x720 

Script for streaming video from RPI usb cam to Zoneminder

Available options:

-h, --help       Print this help and exit
-d, --debug      Print script debug info
-j, --mjpeg      Use MJPEG-STREAMER instead of Ffmpeg
-a, --audio      Add Audio
-r, --resolution Set resolution of video
-w, --watch      Restart FFMPEG if it stops
-u, --uptimekuma Curl Uptime Kuma url when ffmpeg stops
-m, --mediamtx   Use MediaMTX to stream to multiple clients

NOTE: IF you use MediaMTX, It is expected that you have the default conf in /etc/mediamtx.conf and mediamtx in /bin/mediamtx
EOF
exit
}
  while :; do
    case "${1-}" in
    -h | --help) usage ;;
    -d | --debug) set -x ;;
    -j | --mjpeg) MODE=mjpeg ;;
    -r | --resolution) RES=$2  && [[ -z $2 ]] && echo "Please provide a resolution" && exit 1;;
    -a | --audio) AUDIO=1 ;;
    -u | --uptimekuma) UPTIME=1 ;;
    -w | --watch) MONITOR=1 ;;
    -m | --mediamtx) MEDIAMTX=1 ;;
    -?*) echo "Unknown option: $1" && exit 0 ;;
    *) break ;;
    esac
    shift
  done
modprobe uvcvideo
WIDTH=$(echo $RES | cut -d 'x' -f 1)
HEIGHT=$(echo $RES | cut -d 'x' -f 2)
function stream() {
v4l2-ctl --set-fmt-video=width=$WIDTH,height=$HEIGHT -d $DEVICE
if [ -c $DEVICE ]; then
  if [ "$MODE" = "H264" ]; then
  echo "Connect to rtsp://$IP:1935/stream for live video"
  if [ $AUDIO = 1 ]; then
    if [ $MEDIAMTX = 1 ]; then
      mediamtx /etc/mediamtx.yml &
      ffmpeg -f video4linux2 -input_format h264 -i $DEVICE -f alsa -i plughw:CARD=gadget,DEV=0 -c:v copy -c:a mp2 -strict -2 -g 1 -tune zerolatency  -video_size $RES -listen 1 -f rtsp rtsp://localhost:8554/cam
    else
      ffmpeg -f video4linux2 -input_format h264 -i $DEVICE -f alsa -i plughw:CARD=gadget,DEV=0 -c:v copy -c:a aac -strict -2 -g 1 -tune zerolatency  -video_size $RES -listen 1 -f rtsp rtsp://$IP:1935/stream
  fi
  else
    if [ $MEDIAMTX = 1 ]; then
      mediamtx /etc/mediamtx.yml &
      ffmpeg -f video4linux2 -input_format h264 -i $DEVICE -c:v copy -an -g 1 -tune zerolatency -video_size $RES -listen 1 -f rtsp rtsp://localhost:8554/cam
    else
      ffmpeg -f video4linux2 -input_format h264 -i $DEVICE -c:v copy -an -g 1 -tune zerolatency -video_size $RES -listen 1 -f rtsp rtsp://$IP:1935/stream
    fi
  fi
  else 
  echo "Connect to http://$IP:8080/?action=stream for live video"
  mjpg_streamer -i 'input_uvc.so -d /dev/video0 -r $RES' -o 'output_http.so -w /root/mjpg-streamer-master/mjpg-streamer-experimental/www'
  fi
else 
  echo "$DEVICE Is not there!"
  NODEVICE=1
fi
}
if [ $MONITOR = 1 ]; then
  while :
  do
  stream
  if [ $UPTIME = 1 ]; then 
    t="$(ping -c 1 $(echo $KUMAURL | cut -d "/" -f 3 ) | sed -ne '/.*time=/{;s///;s/\..*//;p;}' | cut -d' ' -f1)"
    curl "$KUMAURL${t}"
  fi
  if [ $NODEVICE = 1 ]; then
    watch -g -n5 ls /dev/video0
    NODEVICE=0
  fi
  done
else 
  stream
  if [ $UPTIME = 1 ]; then 
    curl "$KUMAURL"
  fi
fi