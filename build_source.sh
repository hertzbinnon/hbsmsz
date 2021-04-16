#!/bin/bash

start=`date "+%s"`
for ((i=0;i<3;i++))
do
{
#       gst-launch-1.0 videotestsrc is-live=TRUE ! timeoverlay text="channel $i" ! videoconvert ! x264enc byte-stream=TRUE key-int-max=25  ! flvmux name=muxer ! filesink location=/home/hertz/sdb1/cerbero/test.hertz/gst-snippets/test_integration/prj/letin.prj/CloudLiveVR/VRStreamMediaService/clips/ch$i.flv audiotestsrc is-live=TRUE ! audioconvert !  voaacenc ! muxer.
        #nohup gst-launch-1.0 videotestsrc is-live=TRUE ! video/x-raw, width=352, height=288  ! timeoverlay text="channel $i" ! videoconvert ! x264enc byte-stream=TRUE key-int-max=25  ! flvmux name=muxer streamable=true ! rtmp2sink location=rtmp://127.0.0.1/live/ch$i audiotestsrc is-live=TRUE wave=$i ! audioconvert !  avenc_aac perfect-timestamp=TRUE ! muxer. > /dev/null 2>&1 &
#       ./gst-launch-1.0 videotestsrc is-live=TRUE  ! video/x-raw, width=1920, height=1080  ! queue ! timeoverlay text="channel 1" ! queue ! videoconvert ! queue ! x264enc byte-stream=TRUE key-int-max=30 ! queue ! flvmux name=muxer streamable=TRUE ! rtmpsink location=rtmp://10.9.91.51/live/ch7 audiotestsrc is-live=TRUE wave=1 ! queue ! audioconvert ! audio/x-raw, rate=48000, channels=2 !  queue !  avenc_aac perfect-timestamp=TRUE bitrate=128000 ! queue ! muxer.
        #./ffmpeg -re -stream_loop -1 -i /home/hertz/sdb1/cerbero/test.hertz/gst-snippets/test_integration/prj/letin.prj/CloudLiveVR/VRStreamMediaService/4k/$i.mp4 -c copy -f flv rtmp://192.168.0.134/live/ch$i
        nohup gst-launch-1.0 videotestsrc is-live=TRUE ! video/x-raw, width=352, height=288  ! timeoverlay text="channel $i" ! videoconvert ! x264enc byte-stream=TRUE key-int-max=25 ! h264parse ! queue ! mpegtsmux name=muxer alignment=7 ! udpsink host=127.0.0.1 port=1234$i audiotestsrc is-live=TRUE wave=$i ! audioconvert !  avenc_aac perfect-timestamp=TRUE ! muxer. > /dev/null 2>&1 &
	#nohup gst-launch-1.0 rtmp2src location=rtmp://10.9.91.51/live/ch$i ! flvdemux name=demuxer demuxer. ! h264parse ! queue min-threshold-time=0 max-size-buffers=0 max-size-bytes=0 max-size-time=0 ! mpegtsmux name=muxer alignment=7 ! queue min-threshold-time=0 max-size-buffers=0 max-size-bytes=0 max-size-time=0 ! udpsink host=127.0.0.1 port=1234$i demuxer. ! aacparse ! queue min-threshold-time=0 max-size-buffers=0 max-size-bytes=0 max-size-time=0 ! muxer. > /dev/null 2>&1 &
}&
done
#wait
end=`date "+%s"`
echo "time: `expr $end - $start`"
nohup ./ffmpeg -report -re -fflags +genpts -fflags nobuffer -probesize 50 -analyzeduration 100 -stream_loop -1 -i ./0-cat.mp4 -c:v copy -acodec copy -f flv rtmp://127.0.0.1/live/ch0 -f mpegts udp://10.9.119.38:12340 > /dev/null 2>&1 &
nohup ./ffmpeg -report -re -fflags +genpts -fflags nobuffer -probesize 50 -analyzeduration 100 -stream_loop -1 -i ./1-cat.mp4 -c:v copy -acodec copy -f flv rtmp://127.0.0.1/live/ch1 -f mpegts udp://10.9.119.38:12341 > /dev/null 2>&1 &
nohup ./ffmpeg -report -re -fflags +genpts -fflags nobuffer -probesize 50 -analyzeduration 100 -stream_loop -1 -i ./2-cat.mp4 -c:v copy -acodec copy -f flv rtmp://127.0.0.1/live/ch2 -f mpegts udp://10.9.119.38:12342 > /dev/null 2>&1 &
nohup ./ffmpeg -report -re -fflags +genpts -fflags nobuffer -probesize 50 -analyzeduration 100 -stream_loop -1 -i ./3-cat.mp4 -c:v copy -acodec copy -f flv rtmp://127.0.0.1/live/ch3 -f mpegts udp://10.9.119.38:12343 > /dev/null 2>&1 &
nohup ./ffmpeg -report -re -fflags +genpts -fflags nobuffer -probesize 50 -analyzeduration 100 -stream_loop -1 -i ./4-cat.mp4 -c:v copy -acodec copy -f flv rtmp://127.0.0.1/live/ch4 -f mpegts udp://10.9.119.38:12343 > /dev/null 2>&1 &

nohup gst-launch-1.0 rtmp2src location=rtmp://127.0.0.1/live/ch3 ! flvdemux name=demuxer demuxer. ! h264parse config-interval=-1 ! video/x-h264,stream-format=byte-stream,alignment=nal  ! queue  ! mpegtsmux name=muxer alignment=7 ! queue ! tcpserversink host=127.0.0.1 port=12341 demuxer. ! aacparse ! queue ! muxer. > /dev/null 2>&1 &
nohup gst-launch-1.0 rtmp2src location=rtmp://127.0.0.1/live/ch2 ! flvdemux name=demuxer demuxer. ! h264parse config-interval=-1 ! video/x-h264,stream-format=byte-stream,alignment=nal  ! queue  ! mpegtsmux name=muxer alignment=7 ! queue ! tcpserversink host=127.0.0.1 port=12342 demuxer. ! aacparse ! queue ! muxer. > /dev/null 2>&1 &
nohup gst-launch-1.0 rtmp2src location=rtmp://127.0.0.1/live/ch1 ! flvdemux name=demuxer demuxer. ! h264parse config-interval=-1 ! video/x-h264,stream-format=byte-stream,alignment=nal  ! queue  ! mpegtsmux name=muxer alignment=7 ! queue ! tcpserversink host=127.0.0.1 port=12343 demuxer. ! aacparse ! queue ! muxer. > /dev/null 2>&1 &
nohup gst-launch-1.0 rtmp2src location=rtmp://127.0.0.1/live/ch0 ! flvdemux name=demuxer demuxer. ! h264parse config-interval=-1 ! video/x-h264,stream-format=byte-stream,alignment=nal  ! queue  ! mpegtsmux name=muxer alignment=7 ! queue ! tcpserversink host=127.0.0.1 port=12344 demuxer. ! aacparse ! queue ! muxer. > /dev/null 2>&1 &
nohup gst-launch-1.0 rtmp2src location=rtmp://127.0.0.1/live/ch4 ! flvdemux name=demuxer demuxer. ! h264parse config-interval=-1 ! video/x-h264,stream-format=byte-stream,alignment=nal  ! queue  ! mpegtsmux name=muxer alignment=7 ! queue ! tcpserversink host=127.0.0.1 port=12345 demuxer. ! aacparse ! queue ! muxer. > /dev/null 2>&1 &

nohup gst-launch-1.0 rtmp2src location=rtmp://127.0.0.1/live/ch0 ! flvdemux name=demuxer demuxer. ! h264parse config-interval=-1 ! queue  ! mpegtsmux name=muxer alignment=7 ! queue ! udpsink host=127.0.0.1 port=12340 demuxer. ! aacparse ! queue ! muxer. > /dev/null 2>&1 &
