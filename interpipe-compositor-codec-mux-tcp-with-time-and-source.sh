#!/bin/bash
echo -e "\n ====== CCTV Example (Switch the scr_pipe to listen in runtime) ====== \n"
switch=3
STOP=0
export GST_PLUGIN_FEATURE_RANK=nvh264dec:259

# Graceful cleanup upon CTRL-C
trap "STOP=1" SIGINT
# #####
gstd-client -p 5000 pipeline_create source0 rtmp2src location=rtmp://127.0.0.1/live/ch0 ! flvdemux name=demuxer demuxer. ! h264parse config-interval=-1 ! video/x-h264,stream-format=byte-stream,alignment=nal  ! queue  ! mpegtsmux name=muxer alignment=7 ! queue ! tcpserversink host=127.0.0.1 port=12341 demuxer. ! aacparse ! queue ! muxer.
gstd-client -p 5000 pipeline_create source1 rtmp2src location=rtmp://127.0.0.1/live/ch2 ! flvdemux name=demuxer demuxer. ! h264parse config-interval=-1 ! video/x-h264,stream-format=byte-stream,alignment=nal  ! queue  ! mpegtsmux name=muxer alignment=7 ! queue ! tcpserversink host=127.0.0.1 port=12342 demuxer. ! aacparse ! queue ! muxer.

gstd-client -p 5000 pipeline_play source0
gstd-client -p 5000 pipeline_play source1
sleep 1
######

# Create pipelines
echo -e "\n ====> Create the scr_pipe_1 \n"
gstd-client pipeline_create pipe_1_src  tcpclientsrc host=127.0.0.1 port=12341 ! tsdemux name=source ! queue ! video/x-h264,stream-format=byte-stream,alignment=nal ! h264parse ! nvh264dec  ! queue ! clockoverlay text=\"channel 1\" \
! "video/x-raw, width=3840, height=1920" ! queue ! interpipesink name=src_1 caps=video/x-raw,width=3840,height=1920 sync=false async=false \
                                                                 source. ! avdec_aac ! queue ! interpipesink name=src_11 caps=audio/mpeg sync=false async=false

echo -e "\n ====> Create the scr_pipe_2 \n"
gstd-client pipeline_create pipe_2_src  tcpclientsrc host=127.0.0.1 port=12342 ! tsdemux name=source ! queue ! video/x-h264,stream-format=byte-stream,alignment=nal ! h264parse ! nvh264dec  ! queue ! clockoverlay text=\"channel 2\"\
! "video/x-raw, width=3840, height=1920" ! queue ! interpipesink name=src_2 caps=video/x-raw,width=3840,height=1920 sync=false async=false \
                                                                 source. ! avdec_aac ! queue ! interpipesink name=src_22 caps=audio/mpeg sync=false async=false


gstd-client pipeline_create pipe_pub_sink flvmux name=muxer ! rtmp2sink location=rtmp://127.0.0.1/live/publish sync=false \
  interpipesrc name=interpipesrcpv listen-to=videocompositorsink is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! videoconvert ! nvh264enc gop-size=30 preset=0 bitrate=1000 ! h264parse ! queue ! muxer. \
  interpipesrc name=interpipesrcpa listen-to=src_11 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! audioconvert ! voaacenc ! aacparse ! queue ! muxer.

echo -e "\n ====> Change to PLAYING STATE \n"
gstd-client pipeline_play pipe_1_src
#gstd-client pipeline_play pipe_11_src
gstd-client pipeline_play pipe_2_src
#gstd-client pipeline_play pipe_22_src
sleep 2

#gstd-client pipeline_play pipe_10_sink
gstd-client pipeline_play pipe_pub_sink


gstd-client pipeline_create pipe_comp compositor name=comp sink_0::zorder=1 sink_1::zorder=0 background=black ! interpipesink name=videocompositorsink caps=video/x-raw sync=false async=false \
	interpipesrc name=videocompositorsrc0 listen-to=src_1  is-live=true allow-renegotiation=true format=3 stream-sync=2 ! queue ! videoconvert ! comp.sink_0 \
	interpipesrc name=videocompositorsrc1 listen-to=src_2  is-live=true allow-renegotiation=true format=3 stream-sync=2 ! queue ! videoconvert ! comp.sink_1 
gstd-client pipeline_play pipe_comp
echo -e "\n ====> Every $switch seconds the sink_pipe will change the src_pipe that is listening to \n"
echo -e "\n ====> Start listening to scr_pipe_1 \n"
sleep $switch

# Start alternating the source pipeline being listened
while :
do
	gstd-client element_set pipe_comp     comp pad-set sink_0::alpha=0\&sink_1::alpha=1
	#gstd-client element_set pipe_pub_sink interpipesrcpv listen-to src_2
	gstd-client element_set pipe_pub_sink interpipesrcpa listen-to src_22
	echo -e "\n ====> Change to listening to scr_pipe_2 \n"
	sleep $switch
	if [ $STOP -ne 0 ]
	then
		break
	fi

	gstd-client element_set pipe_comp     comp pad-set sink_0::alpha=1\&sink_1::alpha=0
	#gstd-client element_set pipe_pub_sink interpipesrcpv listen-to src_1
	gstd-client element_set pipe_pub_sink interpipesrcpa listen-to src_11
	echo -e "\n ====> Change to listening to scr_pipe_1 \n"
	echo -e "\n ====> Type Ctrl+C to stop the example execution, otherwise it will iterate infinitely!\n"
	sleep $switch
	if [ $STOP -ne 0 ]
	then
		break
	fi
done

gstd-client -p 5000 pipeline_delete source0
gstd-client -p 5000 pipeline_delete source1
# Delete Pipelines
gstd-client pipeline_delete pipe_1_src
#gstd-client pipeline_delete pipe_11_src
gstd-client pipeline_delete pipe_2_src
#gstd-client pipeline_delete pipe_22_src

#gstd-client pipeline_delete pipe_9_sink
#gstd-client pipeline_delete pipe_10_sink

gstd-client pipeline_delete pipe_comp
gstd-client pipeline_delete pipe_pub_sink

echo -e "\n ====> CCTV Example Finished!!! \n"
