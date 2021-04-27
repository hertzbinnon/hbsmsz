#!/bin/bash
echo -e "\n ====== Director Bench mark  ====== \n"
SWITCH=3.4
NUMS=6
STOP=0
export GST_PLUGIN_FEATURE_RANK=nvh264dec:259

# Graceful cleanup upon CTRL-C
trap "STOP=1" SIGINT

for ((i=1; i<${NUMS}; i++))
do
{
  echo -e "\n ====> Create the src $i \n"
  gstd-client pipeline_create pipe_${i}_src  tcpclientsrc host=127.0.0.1 port=1234$i ! tsdemux name=source ! queue ! video/x-h264,stream-format=byte-stream,alignment=nal ! h264parse ! nvh264dec  \
   ! "video/x-raw, width=3840, height=1920" ! queue ! interpipesink name=src_$i caps=video/x-raw,width=3840,height=1920 sync=false async=false \
                                                                 source. ! avdec_aac ! queue ! interpipesink name=src_$i$i caps=audio/mpeg sync=false async=false
}
done

gstd-client pipeline_create pipe_4_sink flvmux name=muxer ! rtmp2sink location=rtmp://127.0.0.1/live/ch5 sync=false \
  interpipesrc name=interpipesrc4v listen-to=src_1 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! videoconvert ! nvh264enc gop-size=30 preset=4 bitrate=10000 ! h264parse ! muxer. \
  interpipesrc name=interpipesrc4a listen-to=src_11 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! audioconvert ! voaacenc ! aacparse ! queue ! muxer.

gstd-client pipeline_create pipe_5_sink flvmux name=muxer ! rtmp2sink location=rtmp://127.0.0.1/live/ch6 sync=false \
  interpipesrc name=interpipesrc5v listen-to=src_1 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! videoscale ! video/x-raw,width=720,height=360 ! videoconvert ! nvh264enc gop-size=30 ! h264parse ! muxer. \
  interpipesrc name=interpipesrc5a listen-to=src_11 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! audioconvert ! voaacenc ! aacparse ! queue ! muxer.
# Change pipelines to PLAYING STATE
echo -e "\n ====> Change to PLAYING STATE \n"
for ((i=1; i<${NUMS}; i++))
do
{
  gstd-client pipeline_play pipe_${i}_src
}
done

gstd-client pipeline_play pipe_4_sink
gstd-client pipeline_play pipe_5_sink

echo -e "\n ====> Every $SWITCH seconds the sink_pipe will change the src_pipe that is listening to \n"
echo -e "\n ====> Start listening to scr_pipe_1 \n"
sleep 3

# Start alternating the source pipeline being listened
for ((i=1; i<${NUMS}; i++))
do
{
	gstd-client element_set pipe_4_sink interpipesrc4v listen-to src_$i
	gstd-client element_set pipe_4_sink interpipesrc4a listen-to src_$i$i
	gstd-client element_set pipe_5_sink interpipesrc5v listen-to src_$i
	gstd-client element_set pipe_5_sink interpipesrc5a listen-to src_$i$i
	echo -e "\n ====> Change to listening to scr_pipe_$i $i \n"
	sleep $SWITCH
	if [ $STOP -ne 0 ]
	then
		break
	fi
}
done


for ((i=0; i<${NUMS}; i++))
do
{
  gstd-client pipeline_delete pipe_${i}_src
}
done
gstd-client pipeline_delete pipe_4_sink
gstd-client pipeline_delete pipe_5_sink

echo -e "\n ====> BenchMark Finished!!! \n"
