#!/bin/bash
echo -e "\n ====== CCTV Example (Switch the scr_pipe to listen in runtime) ====== \n"
switch=5

STOP=0
export GST_PLUGIN_FEATURE_RANK=nvh264dec:259

# Graceful cleanup upon CTRL-C
trap "STOP=1" SIGINT
# #####
gstd-client -p 5000 pipeline_create source0 rtmp2src location=rtmp://127.0.0.1/live/ch1 ! flvdemux name=demuxer demuxer. ! h264parse config-interval=-1 ! video/x-h264,stream-format=byte-stream,alignment=nal  ! queue  ! mpegtsmux name=muxer alignment=7 ! queue ! tcpserversink host=127.0.0.1 port=12341 demuxer. ! aacparse ! queue ! muxer.
gstd-client -p 5000 pipeline_create source1 rtmp2src location=rtmp://127.0.0.1/live/ch1 ! flvdemux name=demuxer demuxer. ! h264parse config-interval=-1 ! video/x-h264,stream-format=byte-stream,alignment=nal  ! queue  ! mpegtsmux name=muxer alignment=7 ! queue ! tcpserversink host=127.0.0.1 port=12342 demuxer. ! aacparse ! queue ! muxer.
gstd-client -p 5000 pipeline_create source2 rtmp2src location=rtmp://127.0.0.1/live/ch1 ! flvdemux name=demuxer demuxer. ! h264parse config-interval=-1 ! video/x-h264,stream-format=byte-stream,alignment=nal  ! queue  ! mpegtsmux name=muxer alignment=7 ! queue ! tcpserversink host=127.0.0.1 port=12343 demuxer. ! aacparse ! queue ! muxer.
gstd-client -p 5000 pipeline_create source3 rtmp2src location=rtmp://127.0.0.1/live/ch1 ! flvdemux name=demuxer demuxer. ! h264parse config-interval=-1 ! video/x-h264,stream-format=byte-stream,alignment=nal  ! queue  ! mpegtsmux name=muxer alignment=7 ! queue ! tcpserversink host=127.0.0.1 port=12344 demuxer. ! aacparse ! queue ! muxer.
gstd-client -p 5000 pipeline_create source4 rtmp2src location=rtmp://127.0.0.1/live/ch1 ! flvdemux name=demuxer demuxer. ! h264parse config-interval=-1 ! video/x-h264,stream-format=byte-stream,alignment=nal  ! queue  ! mpegtsmux name=muxer alignment=7 ! queue ! tcpserversink host=127.0.0.1 port=12345 demuxer. ! aacparse ! queue ! muxer.

gstd-client -p 5000 pipeline_play source0
gstd-client -p 5000 pipeline_play source1
gstd-client -p 5000 pipeline_play source2
gstd-client -p 5000 pipeline_play source3
gstd-client -p 5000 pipeline_play source4
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

echo -e "\n ====> Create the scr_pipe_3 \n"
gstd-client pipeline_create pipe_3_src  tcpclientsrc host=127.0.0.1 port=12343 ! tsdemux name=source ! queue ! video/x-h264,stream-format=byte-stream,alignment=nal ! h264parse ! nvh264dec  ! queue ! clockoverlay text=\"channel 3\"\
! "video/x-raw, width=3840, height=1920" ! queue ! interpipesink name=src_3 caps=video/x-raw,width=3840,height=1920 sync=false async=false \
                                                                 source. ! avdec_aac ! queue ! interpipesink name=src_33 caps=audio/mpeg sync=false async=false

echo -e "\n ====> Create the scr_pipe_4 \n"
gstd-client pipeline_create pipe_4_src  tcpclientsrc host=127.0.0.1 port=12344 ! tsdemux name=source ! queue ! video/x-h264,stream-format=byte-stream,alignment=nal ! h264parse ! nvh264dec  ! queue ! clockoverlay text=\"channel 4\"\
! "video/x-raw, width=3840, height=1920" ! queue ! interpipesink name=src_4 caps=video/x-raw,width=3840,height=1920 sync=false async=false \
                                                                 source. ! avdec_aac ! queue ! interpipesink name=src_44 caps=audio/mpeg sync=false async=false
echo -e "\n ====> Create the scr_pipe_5 \n"
gstd-client pipeline_create pipe_5_src  tcpclientsrc host=127.0.0.1 port=12345 ! tsdemux name=source ! queue ! video/x-h264,stream-format=byte-stream,alignment=nal ! h264parse ! nvh264dec  ! queue ! clockoverlay text=\"channel 5\"\
! "video/x-raw, width=3840, height=1920" ! queue ! interpipesink name=src_5 caps=video/x-raw,width=3840,height=1920 sync=false async=false \
                                                                 source. ! avdec_aac ! queue ! interpipesink name=src_55 caps=audio/mpeg sync=false async=false

gstd-client pipeline_create pipe_pub_sink flvmux name=muxer ! rtmp2sink location=rtmp://127.0.0.1/live/publish sync=false \
  interpipesrc name=interpipesrcpv listen-to=videocompositorsink  is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! videoconvert ! nvh264enc gop-size=30 preset=0 bitrate=2000 ! h264parse ! queue ! muxer. \
  interpipesrc name=interpipesrcpa listen-to=src_11 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! audioconvert ! voaacenc ! aacparse ! queue ! muxer.

gstd-client pipeline_create pipe_pre_sink flvmux name=muxer ! rtmp2sink location=rtmp://127.0.0.1/live/preview sync=false \
  interpipesrc name=interpipesrcvv listen-to=videocompositorsink is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! videoscale ! video/x-raw,width=960,height=480 ! videoconvert ! queue ! nvh264enc gop-size=30 bitrate=1000 ! h264parse ! queue ! muxer. \
  interpipesrc name=interpipesrcva listen-to=src_11 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! audioconvert ! volume volume=2 ! rsaudioecho ! audioconvert ! voaacenc ! aacparse ! queue ! muxer.
#interpipesrc name=interpipesrcva listen-to=src_11 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! audioconvert ! volume volume=10 ! queue ! audioresample ! rsaudioloudnorm loudness-target=-5 loudness-range-target=20 ! audioresample ! queue ! audioconvert ! voaacenc ! queue ! aacparse ! queue ! muxer.
# Change pipelines to PLAYING STATE
gstd-client pipeline_create pipe_1_sink flvmux name=muxer ! rtmp2sink location=rtmp://127.0.0.1/live/chan-id-1 sync=false \
  interpipesrc name=interpipesrc1v listen-to=src_1 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! videoscale ! video/x-raw,width=960,height=480 ! videoconvert ! queue ! nvh264enc gop-size=30 bitrate=1000 ! h264parse ! queue ! muxer. \
  interpipesrc name=interpipesrc1a listen-to=src_11 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! audioconvert ! volume volume=2 ! rsaudioecho ! audioconvert ! voaacenc ! aacparse ! queue ! muxer.
gstd-client pipeline_create pipe_2_sink flvmux name=muxer ! rtmp2sink location=rtmp://127.0.0.1/live/chan-id-2 sync=false \
  interpipesrc name=interpipesrc2v listen-to=src_2 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! videoscale ! video/x-raw,width=960,height=480 ! videoconvert ! queue ! nvh264enc gop-size=30 bitrate=1000 ! h264parse ! queue ! muxer. \
  interpipesrc name=interpipesrc2a listen-to=src_22 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! audioconvert ! volume volume=2 ! rsaudioecho ! audioconvert ! voaacenc ! aacparse ! queue ! muxer.
gstd-client pipeline_create pipe_3_sink flvmux name=muxer ! rtmp2sink location=rtmp://127.0.0.1/live/chan-id-3 sync=false \
  interpipesrc name=interpipesrc3v listen-to=src_3 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! videoscale ! video/x-raw,width=960,height=480 ! videoconvert ! queue ! nvh264enc gop-size=30 bitrate=1000 ! h264parse ! queue ! muxer. \
  interpipesrc name=interpipesrc3a listen-to=src_33 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! audioconvert ! volume volume=2 ! rsaudioecho ! audioconvert ! voaacenc ! aacparse ! queue ! muxer.
gstd-client pipeline_create pipe_4_sink flvmux name=muxer ! rtmp2sink location=rtmp://127.0.0.1/live/chan-id-4 sync=false \
  interpipesrc name=interpipesrc4v listen-to=src_4 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! videoscale ! video/x-raw,width=960,height=480 ! videoconvert ! queue ! nvh264enc gop-size=30 bitrate=1000 ! h264parse ! queue ! muxer. \
  interpipesrc name=interpipesrc4a listen-to=src_44 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! audioconvert ! volume volume=2 ! rsaudioecho ! audioconvert ! voaacenc ! aacparse ! queue ! muxer.
gstd-client pipeline_create pipe_5_sink flvmux name=muxer ! rtmp2sink location=rtmp://127.0.0.1/live/chan-id-5 sync=false \
  interpipesrc name=interpipesrc5v listen-to=src_5 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! videoscale ! video/x-raw,width=960,height=480 ! videoconvert ! queue ! nvh264enc gop-size=30 bitrate=1000 ! h264parse ! queue ! muxer. \
  interpipesrc name=interpipesrc5a listen-to=src_55 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! audioconvert ! volume volume=2 ! rsaudioecho ! audioconvert ! voaacenc ! aacparse ! queue ! muxer.
gstd-client pipeline_play pipe_1_src
#gstd-client pipeline_play pipe_11_src
gstd-client pipeline_play pipe_2_src
#gstd-client pipeline_play pipe_22_src
gstd-client pipeline_play pipe_3_src
#gstd-client pipeline_play pipe_33_src
gstd-client pipeline_play pipe_4_src
gstd-client pipeline_play pipe_5_src

sleep 1
gstd-client pipeline_create pipe_comp compositor name=comp \
	sink_1::alpha=1 sink_2::alpha=0 sink_3::alpha=0 sink_4::alpha=0 sink_5::alpha=0 sink_6::alpha=0 sink_7::alpha=0 sink_8::alpha=0 sink_9::alpha=0 sink_10::alpha=0 \
	sink_1::zorder=10 sink_2::zorder=9 sink_3::zorder=8 sink_4::zorder=7 sink_5::zorder=6 sink_6::zorder=5 sink_7::zorder=4 sink_8::zorder=3 sink_9::zorder=2 sink_10::zorder=1 background=black ! \
	interpipesink name=videocompositorsink caps=video/x-raw sync=false async=false \
	interpipesrc name=videocompositorsrc1 listen-to=src_1  is-live=true allow-renegotiation=true format=3 stream-sync=2 ! queue ! videoconvert ! comp.sink_1 \
	interpipesrc name=videocompositorsrc2 listen-to=src_2  is-live=true allow-renegotiation=true format=3 stream-sync=2 ! queue ! videoconvert ! comp.sink_2 \
	interpipesrc name=videocompositorsrc3 listen-to=src_3  is-live=true allow-renegotiation=true format=3 stream-sync=2 ! queue ! videoconvert ! comp.sink_3 \
	interpipesrc name=videocompositorsrc4 listen-to=src_4  is-live=true allow-renegotiation=true format=3 stream-sync=2 ! queue ! videoconvert ! comp.sink_4 \
	interpipesrc name=videocompositorsrc5 listen-to=src_5  is-live=true allow-renegotiation=true format=3 stream-sync=2 ! queue ! videoconvert ! comp.sink_5 
sleep 1
gstd-client pipeline_play pipe_comp
# NOTE: the pipe_comp would be renegoted if pipe_comp set play to after pre_sink

gstd-client pipeline_play pipe_1_sink
gstd-client pipeline_play pipe_2_sink
gstd-client pipeline_play pipe_3_sink
gstd-client pipeline_play pipe_4_sink
gstd-client pipeline_play pipe_5_sink
gstd-client pipeline_play pipe_pub_sink
gstd-client pipeline_play pipe_pre_sink
sleep 1
echo -e "\n ====> Every $switch seconds the sink_pipe will change the src_pipe that is listening to \n"
echo -e "\n ====> Start listening to scr_pipe_1 \n"
sleep $switch

# Start alternating the source pipeline being listened
while :
do
	gstd-client element_set pipe_comp comp pad-set sink_1::alpha=0\&sink_2::alpha=1\&sink_3::alpha=0\&sink_4::alpha=0\&sink_5::alpha=0
	#gstd-client element_set pipe_comp comp pad-set sink_1::zorder=9\&sink_2::zorder=10\&sink_3::zorder=8\&sink_4::zorder=7\&sink_5::zorder=6\&sink_6::zorder=5\&sink_7::zorder=4\&sink_8::zorder=3\&sink_9::zorder=2\&sink_10::zorder=1
	gstd-client element_set pipe_pub_sink interpipesrcpa listen-to src_22
	gstd-client element_set pipe_pre_sink interpipesrcva listen-to src_22
	echo -e "\n ====> Change to listening to scr_pipe_2 \n"
	sleep $switch
	if [ $STOP -ne 0 ]
	then
		break
	fi

	gstd-client element_set pipe_comp comp pad-set sink_1::alpha=0\&sink_2::alpha=0\&sink_3::alpha=1\&sink_4::alpha=0\&sink_5::alpha=0
	#gstd-client element_set pipe_comp comp pad-set sink_1::zorder=0\&sink_2::zorder=0\&sink_3::zorder=0\&sink_4::zorder=0\&sink_5::zorder=0\&sink_6::zorder=0\&sink_7::zorder=0\&sink_8::zorder=0\&sink_9::zorder=0\&sink_10::zorder=0
	gstd-client element_set pipe_pub_sink interpipesrcpa listen-to src_33
	gstd-client element_set pipe_pre_sink interpipesrcva listen-to src_33
	echo -e "\n ====> Change to listening to scr_pipe_3 \n"
	sleep $switch
	if [ $STOP -ne 0 ]
	then
		break
	fi

	gstd-client element_set pipe_comp comp pad-set sink_1::alpha=0\&sink_2::alpha=0\&sink_3::alpha=0\&sink_4::alpha=1\&sink_5::alpha=0
	#gstd-client element_set pipe_comp comp pad-set sink_1::zorder=0\&sink_2::zorder=0\&sink_3::zorder=0\&sink_4::zorder=0\&sink_5::zorder=0\&sink_6::zorder=0\&sink_7::zorder=0\&sink_8::zorder=0\&sink_9::zorder=0\&sink_10::zorder=0
	gstd-client element_set pipe_pub_sink interpipesrcpa listen-to src_44
	gstd-client element_set pipe_pre_sink interpipesrcva listen-to src_44
	echo -e "\n ====> Change to listening to scr_pipe_4 \n"
	sleep $switch
	if [ $STOP -ne 0 ]
	then
		break
	fi

	gstd-client element_set pipe_comp comp pad-set sink_1::alpha=0\&sink_2::alpha=0\&sink_3::alpha=0\&sink_4::alpha=0\&sink_5::alpha=1
	#gstd-client element_set pipe_comp comp pad-set sink_1::zorder=0\&sink_2::zorder=0\&sink_3::zorder=0\&sink_4::zorder=0\&sink_5::zorder=0\&sink_6::zorder=0\&sink_7::zorder=0\&sink_8::zorder=0\&sink_9::zorder=0\&sink_10::zorder=0
	gstd-client element_set pipe_pub_sink interpipesrcpa listen-to src_55
	gstd-client element_set pipe_pre_sink interpipesrcva listen-to src_55
	echo -e "\n ====> Change to listening to scr_pipe_5 \n"
	sleep $switch
	if [ $STOP -ne 0 ]
	then
		break
	fi

	gstd-client element_set pipe_comp comp pad-set sink_1::alpha=1\&sink_2::alpha=0\&sink_3::alpha=0\&sink_4::alpha=0\&sink_5::alpha=0
	#gstd-client element_set pipe_comp comp pad-set sink_1::zorder=0\&sink_2::zorder=0\&sink_3::zorder=0\&sink_4::zorder=0\&sink_5::zorder=0\&sink_6::zorder=0\&sink_7::zorder=0\&sink_8::zorder=0\&sink_9::zorder=0\&sink_10::zorder=0
	gstd-client element_set pipe_pub_sink interpipesrcpa listen-to src_11
	gstd-client element_set pipe_pre_sink interpipesrcva listen-to src_11
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
gstd-client -p 5000 pipeline_delete source2
gstd-client -p 5000 pipeline_delete source3
gstd-client -p 5000 pipeline_delete source4
# Delete Pipelines
gstd-client pipeline_delete pipe_1_src
#gstd-client pipeline_delete pipe_11_src
gstd-client pipeline_delete pipe_2_src
#gstd-client pipeline_delete pipe_22_src
gstd-client pipeline_delete pipe_3_src
#gstd-client pipeline_delete pipe_33_src
gstd-client pipeline_delete pipe_4_src
gstd-client pipeline_delete pipe_5_src

gstd-client pipeline_delete pipe_1_sink
gstd-client pipeline_delete pipe_2_sink
gstd-client pipeline_delete pipe_3_sink
gstd-client pipeline_delete pipe_4_sink
gstd-client pipeline_delete pipe_5_sink

gstd-client pipeline_delete pipe_pub_sink
gstd-client pipeline_delete pipe_pre_sink

gstd-client pipeline_delete pipe_comp
echo -e "\n ====> CCTV Example Finished!!! \n"
