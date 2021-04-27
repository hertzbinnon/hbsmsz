#!/bin/bash
#gst-launch-1.0 videotestsrc pattern=ball is-live=true ! "video/x-raw, framerate=30/1, width=640, height=480, format=I420" ! queue ! interpipesink name=src_1 caps=video/x-raw,width=640,height=480,framerate=30/1 sync=false async=false   interpipesrc name=interpipesrc1 listen-to=src_1 is-live=true allow-renegotiation=true ! videoconvert ! x264enc ! h264parse ! mpegtsmux ! udpsink host=192.168.0.166 max-bitrate=7000000  port=12349 sync=true
#gst-launch-1.0 videotestsrc pattern=ball is-live=true ! "video/x-raw, framerate=30/1, width=640, height=480, format=I420" ! queue ! interpipesink name=src_1 caps=video/x-raw,width=640,height=480,framerate=30/1 sync=false async=false audiotestsrc wave=0 is-live=true ! queue ! interpipesink name=src_11 sync=false async=false interpipesrc name=interpipesrc1 listen-to=src_1 is-live=true allow-renegotiation=true ! videoconvert ! x264enc ! h264parse ! queue ! flvmux name=muxer ! rtmp2sink location=rtmp://127.0.0.1/live/chan0 sync=false interpipesrc name=interpipesrc11 listen-to=src_11 is-live=true allow-renegotiation=true ! audioconvert ! voaacenc ! aacparse ! queue ! muxer.
#gst-launch-1.0 videotestsrc pattern=ball is-live=true ! "video/x-raw, framerate=30/1, width=640, height=480, format=I420" ! queue ! interpipesink name=src_1 caps=video/x-raw,width=640,height=480,framerate=30/1 sync=false async=false   interpipesrc name=interpipesrc1 listen-to=src_1 is-live=true allow-renegotiation=true ! videoconvert ! x264enc ! h264parse ! mpegtsmux ! udpsink host=192.168.0.166 max-bitrate=7000000  port=12349 sync=false
# gst-launch-1.0 uridecodebin uri=rtmp://127.0.0.1/live/ch0 name=source ! video/x-raw, framerate=30/1, width=352, height=288, format=Y444_10LE ! queue ! interpipesink name=src_1 caps="video/x-raw,width=352,height=288,framerate=30/1" sync=false async=false forward-events=true forward-eos=true  interpipesrc name=interpipesrc1 listen-to=src_1 is-live=true allow-renegotiation=true stream-type=0 ! queue ! videoconvert ! x264enc ! h264parse ! queue ! mpegtsmux name=muxer latency=1000000000 alignment=7 ! queue ! udpsink host=192.168.0.166 port=12349 sync=false async=false

# gst-launch-1.0 uridecodebin uri=udp://127.0.0.1:12346 name=source ! "video/x-raw, framerate=30/1, width=352, height=288, format=Y444_10LE" ! queue ! interpipesink name=src_1 caps=video/x-raw,width=352,height=288,framerate=30/1 sync=false async=false  source. ! queue ! audioconvert ! voaacenc ! aacparse ! queue ! interpipesink name=src_11 caps=audio/mpeg sync=false async=false flvmux name=muxer ! rtmp2sink location=rtmp://127.0.0.1/live/ch5 sync=false interpipesrc name=interpipesrc1 listen-to=src_1 is-live=true allow-renegotiation=true format=3 stream-sync=2 ! queue ! videoconvert ! x264enc key-int-max=30 ! h264parse !  muxer. interpipesrc name=interpipesrc11 listen-to=src_11 is-live=true allow-renegotiation=true format=3 stream-sync=2 ! queue ! aacparse ! muxer.

#gst-launch-1.0 -v rtmp2src location=rtmp://127.0.0.1/live/ch0 timeout=10 ! flvdemux  name=source ! h264parse ! avdec_h264 ! video/x-raw, framerate=30/1, width=352, height=288 ! queue ! interpipesink name=src_1 caps="video/x-raw,width=352,height=288,framerate=30/1" sync=false async=false forward-events=true forward-eos=true  interpipesrc name=interpipesrc1 listen-to=src_1 is-live=true allow-renegotiation=true format=3 stream-sync=2 ! queue ! videoconvert ! x264enc ! h264parse ! queue ! mpegtsmux name=muxer alignment=7 ! queue ! udpsink host=192.168.0.166 port=12349 sync=false async=false
echo -e "\n ====== CCTV Example (Switch the scr_pipe to listen in runtime) ====== \n"
switch=0.4

STOP=0
export GST_PLUGIN_FEATURE_RANK=nvh264dec:259

# Graceful cleanup upon CTRL-C
trap "STOP=1" SIGINT

# Create pipelines
echo -e "\n ====> Create the scr_pipe_1 \n"
gstd-client pipeline_create pipe_1_src  tcpclientsrc host=127.0.0.1 port=12343 ! tsdemux name=source ! queue ! video/x-h264,stream-format=byte-stream,alignment=nal ! h264parse ! nvh264dec  \
! "video/x-raw, width=3840, height=1920" ! queue ! interpipesink name=src_1 caps=video/x-raw,width=3840,height=1920 sync=false async=false \
                                                                 source. ! avdec_aac ! queue ! interpipesink name=src_11 caps=audio/mpeg sync=false async=false

echo -e "\n ====> Create the scr_pipe_2 \n"
gstd-client pipeline_create pipe_2_src  tcpclientsrc host=127.0.0.1 port=12342 ! tsdemux name=source ! queue ! video/x-h264,stream-format=byte-stream,alignment=nal ! h264parse ! nvh264dec  \
! "video/x-raw, width=3840, height=1920" ! queue ! interpipesink name=src_2 caps=video/x-raw,width=3840,height=1920 sync=false async=false \
                                                                 source. ! avdec_aac ! queue ! interpipesink name=src_22 caps=audio/mpeg sync=false async=false

echo -e "\n ====> Create the scr_pipe_3 \n"
gstd-client pipeline_create pipe_3_src  tcpclientsrc host=127.0.0.1 port=12341 ! tsdemux name=source ! queue ! video/x-h264,stream-format=byte-stream,alignment=nal ! h264parse ! nvh264dec  \
! "video/x-raw, width=3840, height=1920" ! queue ! interpipesink name=src_3 caps=video/x-raw,width=3840,height=1920 sync=false async=false \
                                                                 source. ! avdec_aac ! queue ! interpipesink name=src_33 caps=audio/mpeg sync=false async=false

echo -e "\n ====> Create the scr_pipe_4 \n"
gstd-client pipeline_create pipe_4_src  tcpclientsrc host=127.0.0.1 port=12344 ! tsdemux name=source ! queue ! video/x-h264,stream-format=byte-stream,alignment=nal ! h264parse ! nvh264dec  \
! "video/x-raw, width=3840, height=1920" ! queue ! interpipesink name=src_4 caps=video/x-raw,width=3840,height=1920 sync=false async=false \
                                                                 source. ! avdec_aac ! queue ! interpipesink name=src_44 caps=audio/mpeg sync=false async=false
echo -e "\n ====> Create the scr_pipe_5 \n"
gstd-client pipeline_create pipe_5_src  tcpclientsrc host=127.0.0.1 port=12345 ! tsdemux name=source ! queue ! video/x-h264,stream-format=byte-stream,alignment=nal ! h264parse ! nvh264dec  \
! "video/x-raw, width=3840, height=1920" ! queue ! interpipesink name=src_5 caps=video/x-raw,width=3840,height=1920 sync=false async=false \
                                                                 source. ! avdec_aac ! queue ! interpipesink name=src_55 caps=audio/mpeg sync=false async=false
echo -e "\n ====> Create the scr_pipe_6 \n"
gstd-client pipeline_create pipe_6_src  tcpclientsrc host=127.0.0.1 port=12343 ! tsdemux name=source ! queue ! video/x-h264,stream-format=byte-stream,alignment=nal ! h264parse ! nvh264dec  \
! "video/x-raw, width=3840, height=1920" ! queue ! interpipesink name=src_6 caps=video/x-raw,width=3840,height=1920 sync=false async=false \
                                                                 source. ! avdec_aac ! queue ! interpipesink name=src_66 caps=audio/mpeg sync=false async=false
echo -e "\n ====> Create the scr_pipe_7 \n"
gstd-client pipeline_create pipe_7_src  tcpclientsrc host=127.0.0.1 port=12342 ! tsdemux name=source ! queue ! video/x-h264,stream-format=byte-stream,alignment=nal ! h264parse ! nvh264dec  \
! "video/x-raw, width=3840, height=1920" ! queue ! interpipesink name=src_7 caps=video/x-raw,width=3840,height=1920 sync=false async=false \
                                                                 source. ! avdec_aac ! queue ! interpipesink name=src_77 caps=audio/mpeg sync=false async=false
echo -e "\n ====> Create the scr_pipe_8 \n"
gstd-client pipeline_create pipe_8_src  tcpclientsrc host=127.0.0.1 port=12341 ! tsdemux name=source ! queue ! video/x-h264,stream-format=byte-stream,alignment=nal ! h264parse ! nvh264dec  \
! "video/x-raw, width=3840, height=1920" ! queue ! interpipesink name=src_8 caps=video/x-raw,width=3840,height=1920 sync=false async=false \
                                                                 source. ! avdec_aac ! queue ! interpipesink name=src_88 caps=audio/mpeg sync=false async=false
echo -e "\n ====> Create the scr_pipe_9 \n"
gstd-client pipeline_create pipe_9_src  tcpclientsrc host=127.0.0.1 port=12344 ! tsdemux name=source ! queue ! video/x-h264,stream-format=byte-stream,alignment=nal ! h264parse ! nvh264dec  \
! "video/x-raw, width=3840, height=1920" ! queue ! interpipesink name=src_9 caps=video/x-raw,width=3840,height=1920 sync=false async=false \
                                                                 source. ! avdec_aac ! queue ! interpipesink name=src_99 caps=audio/mpeg sync=false async=false
echo -e "\n ====> Create the scr_pipe_10 \n"
gstd-client pipeline_create pipe_10_src tcpclientsrc host=127.0.0.1 port=12345 ! tsdemux name=source ! queue ! video/x-h264,stream-format=byte-stream,alignment=nal ! h264parse ! nvh264dec  \
! "video/x-raw, width=3840, height=1920" ! queue ! interpipesink name=src_10 caps=video/x-raw,width=3840,height=1920 sync=false async=false \
                                                                 source. ! avdec_aac ! queue ! interpipesink name=src_1010 caps=audio/mpeg sync=false async=false
#echo -e "\n ====> Create the scr_pipe_2 \n"
#gstd-client pipeline_create pipe_2_src videotestsrc pattern=snow is-live=true \
#! "video/x-raw, framerate=30/1, width=640, height=480, format=I420" ! queue ! interpipesink name=src_2 caps=video/x-raw sync=false async=false 

#gstd-client pipeline_create pipe_22_src audiotestsrc wave=1 is-live=true ! queue ! audioconvert ! voaacenc ! aacparse ! queue ! interpipesink name=src_22 caps=audio/mpeg sync=false async=false

#echo -e "\n ====> Create the scr_pipe_3 \n"
#gstd-client pipeline_create pipe_3_src videotestsrc pattern=smpte is-live=true \
#! "video/x-raw, framerate=30/1, width=640, height=480, format=I420" ! queue ! interpipesink name=src_3 caps=video/x-raw sync=false async=false 

#gstd-client pipeline_create pipe_33_src audiotestsrc wave=2 is-live=true ! queue ! audioconvert ! voaacenc ! aacparse ! queue ! interpipesink name=src_33 caps=audio/mpeg sync=false async=false

#echo -e "\n ====> Create the scr_pipe_2 \n"
#gstd-client pipeline_create pipe_2_src videotestsrc pattern=snow is-live=true \
#! "video/x-raw, framerate=30/1, width=640, height=480, format=I420" ! queue ! interpipesink name=src_2 caps=video/x-raw,width=640,height=480,framerate=30/1 sync=false async=false \
#audiotestsrc wave=1 is-live=true ! queue ! audioconvert ! voaacenc ! aacparse ! queue ! interpipesink name=src_22 sync=false async=false

#echo -e "\n ====> Create the scr_pipe_3 \n"
#gstd-client pipeline_create pipe_3_src videotestsrc pattern=smpte is-live=true \
#! "video/x-raw, framerate=30/1, width=640, height=480, format=I420" ! queue ! interpipesink name=src_3 caps=video/x-raw,width=640,height=480,framerate=30/1 sync=false async=false \
#audiotestsrc wave=2 is-live=true ! queue ! audioconvert ! voaacenc ! aacparse ! queue ! interpipesink name=src_33 sync=false async=false

echo -e "\n ====> Create the sink_pipe_4 (listener) \n"
#gstd-client pipeline_create pipe_4_sink interpipesrc name=interpipesrc1 listen-to=src_1 \
#is-live=true allow-renegotiation=true ! videoconvert ! x264enc ! h264parse ! mpegtsmux ! udpsink host=192.168.0.166 max-bitrate=7000000  port=12349 sync=false

#gstd-client pipeline_create pipe_4_sink interpipesrc name=interpipesrc1 listen-to=src_1 \
#is-live=true allow-renegotiation=true ! videoconvert ! x264enc ! h264parse ! flvmux !  rtmp2sink location=rtmp://127.0.0.1/live/chan0 sync=false

#gstd-client pipeline_create pipe_4_sink interpipesrc name=interpipesrc1 listen-to=src_1 is-live=true allow-renegotiation=true ! videoconvert ! x264enc ! h264parse ! queue ! flvmux name=muxer ! rtmp2sink location=rtmp://127.0.0.1/live/chan0 sync=false interpipesrc name=interpipesrc11 listen-to=src_11 is-live=true allow-renegotiation=true ! audioconvert ! voaacenc ! aacparse ! queue ! muxer.

gstd-client pipeline_create pipe_4_sink flvmux name=muxer ! rtmp2sink location=rtmp://127.0.0.1/live/ch5 sync=false \
  interpipesrc name=interpipesrc4v listen-to=src_1 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! videoconvert ! nvh264enc gop-size=30 preset=4 bitrate=10000 ! h264parse ! muxer. \
  interpipesrc name=interpipesrc4a listen-to=src_11 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! audioconvert ! voaacenc ! aacparse ! queue ! muxer.

gstd-client pipeline_create pipe_5_sink flvmux name=muxer ! rtmp2sink location=rtmp://127.0.0.1/live/ch6 sync=false \
  interpipesrc name=interpipesrc5v listen-to=src_1 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! videoscale ! video/x-raw,width=720,height=360 ! videoconvert ! nvh264enc gop-size=30 ! h264parse ! muxer. \
  interpipesrc name=interpipesrc5a listen-to=src_11 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! audioconvert ! volume volume=2 ! rsaudioecho ! audioconvert ! voaacenc ! aacparse ! queue ! muxer.
#interpipesrc name=interpipesrc5a listen-to=src_11 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! audioconvert ! volume volume=10 ! queue ! audioresample ! rsaudioloudnorm loudness-target=-5 loudness-range-target=20 ! audioresample ! queue ! audioconvert ! voaacenc ! queue ! aacparse ! queue ! muxer.
# Change pipelines to PLAYING STATE
echo -e "\n ====> Change to PLAYING STATE \n"
gstd-client pipeline_play pipe_1_src
#gstd-client pipeline_play pipe_11_src
gstd-client pipeline_play pipe_2_src
#gstd-client pipeline_play pipe_22_src
gstd-client pipeline_play pipe_3_src
#gstd-client pipeline_play pipe_33_src
gstd-client pipeline_play pipe_4_src
gstd-client pipeline_play pipe_5_src
gstd-client pipeline_play pipe_6_src
gstd-client pipeline_play pipe_7_src
gstd-client pipeline_play pipe_8_src
gstd-client pipeline_play pipe_9_src
gstd-client pipeline_play pipe_10_src

gstd-client pipeline_play pipe_4_sink
gstd-client pipeline_play pipe_5_sink

echo -e "\n ====> Every 3 seconds the sink_pipe will change the src_pipe that is listening to \n"
echo -e "\n ====> Start listening to scr_pipe_1 \n"
sleep 3

# Start alternating the source pipeline being listened
while :
do
	gstd-client element_set pipe_4_sink interpipesrc4v listen-to src_2
	gstd-client element_set pipe_4_sink interpipesrc4a listen-to src_22
	gstd-client element_set pipe_5_sink interpipesrc5v listen-to src_2
	gstd-client element_set pipe_5_sink interpipesrc5a listen-to src_22
	echo -e "\n ====> Change to listening to scr_pipe_2 \n"
	sleep $switch
	if [ $STOP -ne 0 ]
	then
		break
	fi

	gstd-client element_set pipe_4_sink interpipesrc4v listen-to src_3
	gstd-client element_set pipe_4_sink interpipesrc4a listen-to src_33
	gstd-client element_set pipe_5_sink interpipesrc5v listen-to src_3
	gstd-client element_set pipe_5_sink interpipesrc5a listen-to src_33
	echo -e "\n ====> Change to listening to scr_pipe_3 \n"
	sleep $switch
	if [ $STOP -ne 0 ]
	then
		break
	fi

	gstd-client element_set pipe_4_sink interpipesrc4v listen-to src_4
	gstd-client element_set pipe_4_sink interpipesrc4a listen-to src_44
	gstd-client element_set pipe_5_sink interpipesrc5v listen-to src_4
	gstd-client element_set pipe_5_sink interpipesrc5a listen-to src_44
	echo -e "\n ====> Change to listening to scr_pipe_4 \n"
	sleep $switch
	if [ $STOP -ne 0 ]
	then
		break
	fi

	gstd-client element_set pipe_4_sink interpipesrc4v listen-to src_5
	gstd-client element_set pipe_4_sink interpipesrc4a listen-to src_55
	gstd-client element_set pipe_5_sink interpipesrc5v listen-to src_5
	gstd-client element_set pipe_5_sink interpipesrc5a listen-to src_55
	echo -e "\n ====> Change to listening to scr_pipe_5 \n"
	sleep $switch
	if [ $STOP -ne 0 ]
	then
		break
	fi

	gstd-client element_set pipe_4_sink interpipesrc4v listen-to src_6
	gstd-client element_set pipe_4_sink interpipesrc4a listen-to src_66
	gstd-client element_set pipe_5_sink interpipesrc5v listen-to src_6
	gstd-client element_set pipe_5_sink interpipesrc5a listen-to src_66
	echo -e "\n ====> Change to listening to scr_pipe_6 \n"
	sleep $switch
	if [ $STOP -ne 0 ]
	then
		break
	fi

	gstd-client element_set pipe_4_sink interpipesrc4v listen-to src_7
	gstd-client element_set pipe_4_sink interpipesrc4a listen-to src_77
	gstd-client element_set pipe_5_sink interpipesrc5v listen-to src_7
	gstd-client element_set pipe_5_sink interpipesrc5a listen-to src_77
	echo -e "\n ====> Change to listening to scr_pipe_7 \n"
	sleep $switch
	if [ $STOP -ne 0 ]
	then
		break
	fi

	gstd-client element_set pipe_4_sink interpipesrc4v listen-to src_8
	gstd-client element_set pipe_4_sink interpipesrc4a listen-to src_88
	gstd-client element_set pipe_5_sink interpipesrc5v listen-to src_8
	gstd-client element_set pipe_5_sink interpipesrc5a listen-to src_88
	echo -e "\n ====> Change to listening to scr_pipe_8 \n"
	sleep $switch
	if [ $STOP -ne 0 ]
	then
		break
	fi

	gstd-client element_set pipe_4_sink interpipesrc4v listen-to src_9
	gstd-client element_set pipe_4_sink interpipesrc4a listen-to src_99
	gstd-client element_set pipe_5_sink interpipesrc5v listen-to src_9
	gstd-client element_set pipe_5_sink interpipesrc5a listen-to src_99
	echo -e "\n ====> Change to listening to scr_pipe_9 \n"
	echo -e "\n ====> Type Ctrl+C to stop the example execution, otherwise it will iterate infinitely!\n"
	sleep $switch
	if [ $STOP -ne 0 ]
	then
		break
	fi

	gstd-client element_set pipe_4_sink interpipesrc4v listen-to src_10
	gstd-client element_set pipe_4_sink interpipesrc4a listen-to src_1010
	gstd-client element_set pipe_5_sink interpipesrc5v listen-to src_10
	gstd-client element_set pipe_5_sink interpipesrc5a listen-to src_1010
	echo -e "\n ====> Change to listening to scr_pipe_10 \n"
	echo -e "\n ====> Type Ctrl+C to stop the example execution, otherwise it will iterate infinitely!\n"
	sleep $switch
	if [ $STOP -ne 0 ]
	then
		break
	fi

	gstd-client element_set pipe_4_sink interpipesrc4v listen-to src_1
	gstd-client element_set pipe_4_sink interpipesrc4a listen-to src_11
	gstd-client element_set pipe_5_sink interpipesrc5v listen-to src_1
	gstd-client element_set pipe_5_sink interpipesrc5a listen-to src_11
	echo -e "\n ====> Change to listening to scr_pipe_1 \n"
	echo -e "\n ====> Type Ctrl+C to stop the example execution, otherwise it will iterate infinitely!\n"
	sleep $switch
	if [ $STOP -ne 0 ]
	then
		break
	fi
done

# Delete Pipelines
gstd-client pipeline_delete pipe_1_src
#gstd-client pipeline_delete pipe_11_src
gstd-client pipeline_delete pipe_2_src
#gstd-client pipeline_delete pipe_22_src
gstd-client pipeline_delete pipe_3_src
#gstd-client pipeline_delete pipe_33_src
gstd-client pipeline_delete pipe_4_src

gstd-client pipeline_delete pipe_5_src

gstd-client pipeline_delete pipe_6_src
gstd-client pipeline_delete pipe_7_src
gstd-client pipeline_delete pipe_8_src
gstd-client pipeline_delete pipe_9_src
gstd-client pipeline_delete pipe_10_src
gstd-client pipeline_delete pipe_4_sink
gstd-client pipeline_delete pipe_5_sink

echo -e "\n ====> CCTV Example Finished!!! \n"
