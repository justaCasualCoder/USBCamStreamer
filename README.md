# USBCamStreamer
This bash script uses [MediaMTX](https://github.com/bluenviron/mediamtx) and [FFmpeg](https://ffmpeg.org/) to stream YOUR usb camera to a browser! It is not actually doing the streaming itself. It just makes getting started with [MediaMTX](https://github.com/bluenviron/mediamtx) and [FFmpeg](https://ffmpeg.org/) streaming a little easier! :)
# Quick Start
Install FFmpeg (Example on Debian/Ubuntu):
```
sudo apt install ffmpeg
```
Get the script:
```
wget https://raw.githubusercontent.com/justaCasualCoder/USBCamStreamer/main/USBCamStreamer.sh && sudo mv USBCamStreamer.sh /bin/USBCamStreamer && sudo chmod +x /bin/USBCamStreamer
```
Download and extract MediaMTX (Example on x86_64):
```
wget https://github.com/bluenviron/mediamtx/releases/download/v1.3.1/mediamtx_v1.3.1_linux_amd64.tar.gz && tar -xf mediamtx_v1.3.1_linux_amd64.tar.gz
```
Install MediaMTX:
```
rm LICENSE && sudo mv mediamtx /bin/ && sudo mv mediamtx.yml /etc/ && sudo chmod +x /bin/mediamtx
```
Run the Script (Example using `/dev/video0` as source  at 720p and MediaMTX):
```
USBCamStreamer -m -d /dev/video0 -r 1280x720
```
See `stream -h` for usage (`man USBCamStreamer`).
# Build
I have made `builddebian.sh` to compile `USBCamStreamer` into a `.deb`. I am planning on making a `PKGBUILD` for Arch Linux in the future.
