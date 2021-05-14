#!/bin/bash
echo -e "\n ====== CCTV Example (Switch the scr_pipe to listen in runtime) ====== \n"
switch=10

STOP=0
export GST_PLUGIN_FEATURE_RANK=nvh264dec:259

# Graceful cleanup upon CTRL-C
trap "STOP=1" SIGINT

# Create pipelines
echo -e "\n ====> Create the scr_pipe_1 \n"
gstd-client pipeline_create pipe_1_src  rtmp2src location=rtmp://10.9.126.203/live/ch0 timeout=10 ! flvdemux name=demuxer ! h264parse config-interval=-1 ! queue  ! mpegtsmux name=muxer alignment=7 ! queue ! tsdemux name=source ! queue ! video/x-h264,stream-format=byte-stream,alignment=nal ! h264parse ! nvh264dec  ! queue ! clockoverlay text=\"channel 1\" \
! "video/x-raw, width=3840, height=1920" ! queue ! interpipesink name=src_1 caps=video/x-raw,width=3840,height=1920 sync=false async=false \
                                                                 demuxer.  ! aacparse ! queue ! muxer. \
                                                                 source. ! avdec_aac ! queue ! interpipesink name=src_11 caps=audio/mpeg sync=false async=false

echo -e "\n ====> Create the scr_pipe_2 \n"
gstd-client pipeline_create pipe_2_src  rtmp2src location=rtmp://10.9.126.203/live/ch1 timeout=10 ! flvdemux name=demuxer ! h264parse config-interval=-1 ! queue  ! mpegtsmux name=muxer alignment=7 ! queue ! tsdemux name=source ! queue ! video/x-h264,stream-format=byte-stream,alignment=nal ! h264parse ! nvh264dec  ! queue ! clockoverlay text=\"channel 2\" \
! "video/x-raw, width=3840, height=1920" ! queue ! interpipesink name=src_2 caps=video/x-raw,width=3840,height=1920 sync=false async=false \
                                                                 demuxer. !  aacparse ! queue ! muxer. \
                                                                 source. ! avdec_aac ! queue ! interpipesink name=src_22 caps=audio/mpeg sync=false async=false
echo -e "\n ====> Create the scr_pipe_3 \n"
gstd-client pipeline_create pipe_3_src  rtmp2src location=rtmp://10.9.126.203/live/ch0 timeout=10 ! flvdemux name=demuxer ! h264parse config-interval=-1 ! queue  ! mpegtsmux name=muxer alignment=7 ! queue ! tsdemux name=source ! queue ! video/x-h264,stream-format=byte-stream,alignment=nal ! h264parse ! nvh264dec  ! queue ! clockoverlay text=\"channel 3\" \
! "video/x-raw, width=3840, height=1920" ! queue ! interpipesink name=src_3 caps=video/x-raw,width=3840,height=1920 sync=false async=false \
                                                                 demuxer. !  aacparse ! queue ! muxer. \
                                                                 source. ! avdec_aac ! queue ! interpipesink name=src_33 caps=audio/mpeg sync=false async=false
echo -e "\n ====> Create the scr_pipe_4 \n"
gstd-client pipeline_create pipe_4_src  rtmp2src location=rtmp://10.9.126.203/live/ch1 timeout=10 ! flvdemux name=demuxer ! h264parse config-interval=-1 ! queue  ! mpegtsmux name=muxer alignment=7 ! queue ! tsdemux name=source ! queue ! video/x-h264,stream-format=byte-stream,alignment=nal ! h264parse ! nvh264dec  ! queue ! clockoverlay text=\"channel 4\" \
! "video/x-raw, width=3840, height=1920" ! queue ! interpipesink name=src_4 caps=video/x-raw,width=3840,height=1920 sync=false async=false \
                                                                 demuxer. !  aacparse ! queue ! muxer. \
                                                                 source. ! avdec_aac ! queue ! interpipesink name=src_44 caps=audio/mpeg sync=false async=false
echo -e "\n ====> Create the scr_pipe_5 \n"
gstd-client pipeline_create pipe_5_src  rtmp2src location=rtmp://10.9.126.203/live/ch0 timeout=10 ! flvdemux name=demuxer ! h264parse config-interval=-1 ! queue  ! mpegtsmux name=muxer alignment=7 ! queue ! tsdemux name=source ! queue ! video/x-h264,stream-format=byte-stream,alignment=nal ! h264parse ! nvh264dec  ! queue ! clockoverlay text=\"channel 5\" \
! "video/x-raw, width=3840, height=1920" ! queue ! interpipesink name=src_5 caps=video/x-raw,width=3840,height=1920 sync=false async=false \
                                                                 demuxer. !  aacparse ! queue ! muxer. \
                                                                 source. ! avdec_aac ! queue ! interpipesink name=src_55 caps=audio/mpeg sync=false async=false
echo -e "\n ====> Create the scr_pipe_6 \n"
gstd-client pipeline_create pipe_6_src  rtmp2src location=rtmp://10.9.126.203/live/ch1 timeout=10 ! flvdemux name=demuxer ! h264parse config-interval=-1 ! queue  ! mpegtsmux name=muxer alignment=7 ! queue ! tsdemux name=source ! queue ! video/x-h264,stream-format=byte-stream,alignment=nal ! h264parse ! nvh264dec  ! queue ! clockoverlay text=\"channel 6\" \
! "video/x-raw, width=3840, height=1920" ! queue ! interpipesink name=src_6 caps=video/x-raw,width=3840,height=1920 sync=false async=false \
                                                                 demuxer. !  aacparse ! queue ! muxer. \
                                                                 source. ! avdec_aac ! queue ! interpipesink name=src_66 caps=audio/mpeg sync=false async=false
echo -e "\n ====> Create the scr_pipe_7 \n"
gstd-client pipeline_create pipe_7_src  rtmp2src location=rtmp://10.9.126.203/live/ch0 timeout=10 ! flvdemux name=demuxer ! h264parse config-interval=-1 ! queue  ! mpegtsmux name=muxer alignment=7 ! queue ! tsdemux name=source ! queue ! video/x-h264,stream-format=byte-stream,alignment=nal ! h264parse ! nvh264dec  ! queue ! clockoverlay text=\"channel 7\" \
! "video/x-raw, width=3840, height=1920" ! queue ! interpipesink name=src_7 caps=video/x-raw,width=3840,height=1920 sync=false async=false \
                                                                 demuxer. !  aacparse ! queue ! muxer. \
                                                                 source. ! avdec_aac ! queue ! interpipesink name=src_77 caps=audio/mpeg sync=false async=false
echo -e "\n ====> Create the scr_pipe_8 \n"
gstd-client pipeline_create pipe_8_src  rtmp2src location=rtmp://10.9.126.203/live/ch1 timeout=10 ! flvdemux name=demuxer ! h264parse config-interval=-1 ! queue  ! mpegtsmux name=muxer alignment=7 ! queue ! tsdemux name=source ! queue ! video/x-h264,stream-format=byte-stream,alignment=nal ! h264parse ! nvh264dec  ! queue ! clockoverlay text=\"channel 8\" \
! "video/x-raw, width=3840, height=1920" ! queue ! interpipesink name=src_8 caps=video/x-raw,width=3840,height=1920 sync=false async=false \
                                                                 demuxer. !  aacparse ! queue ! muxer. \
                                                                 source. ! avdec_aac ! queue ! interpipesink name=src_88 caps=audio/mpeg sync=false async=false



gstd-client pipeline_create pipe_pub_sink flvmux name=muxer ! rtmp2sink location=rtmp://127.0.0.1/live/publish sync=false \
  interpipesrc name=interpipesrcpv listen-to=src_1 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! videoconvert ! nvh264enc gop-size=30 preset=0 bitrate=2000 ! h264parse ! queue ! muxer. \
  interpipesrc name=interpipesrcpa listen-to=src_11 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! audioconvert ! voaacenc ! aacparse ! queue ! muxer.

gstd-client pipeline_create pipe_pre_sink flvmux name=muxer ! rtmp2sink location=rtmp://127.0.0.1/live/preview sync=false \
  interpipesrc name=interpipesrcvv listen-to=src_1 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! videoscale ! video/x-raw,width=960,height=480 ! videoconvert ! queue ! nvh264enc gop-size=30 bitrate=1000 ! h264parse ! queue ! muxer. \
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
  interpipesrc name=interpipesrc3v listen-to=src_3 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! videoscale ! video/x-raw,width=960,height=480 ! videoconvert ! queue ! x264enc key-int-max=30 speed-preset=1 byte-stream=TRUE ! h264parse ! queue ! muxer. \
  interpipesrc name=interpipesrc3a listen-to=src_33 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! audioconvert ! volume volume=2 ! rsaudioecho ! audioconvert ! voaacenc ! aacparse ! queue ! muxer.
gstd-client pipeline_create pipe_4_sink flvmux name=muxer ! rtmp2sink location=rtmp://127.0.0.1/live/chan-id-4 sync=false \
  interpipesrc name=interpipesrc4v listen-to=src_4 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! videoscale ! video/x-raw,width=960,height=480 ! videoconvert ! queue ! x264enc key-int-max=30 speed-preset=1 byte-stream=TRUE ! h264parse ! queue ! muxer. \
  interpipesrc name=interpipesrc4a listen-to=src_44 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! audioconvert ! volume volume=2 ! rsaudioecho ! audioconvert ! voaacenc ! aacparse ! queue ! muxer.
gstd-client pipeline_create pipe_5_sink flvmux name=muxer ! rtmp2sink location=rtmp://127.0.0.1/live/chan-id-5 sync=false \
  interpipesrc name=interpipesrc5v listen-to=src_5 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! videoscale ! video/x-raw,width=960,height=480 ! videoconvert ! queue ! x264enc key-int-max=30 speed-preset=1 byte-stream=TRUE ! h264parse ! queue ! muxer. \
  interpipesrc name=interpipesrc5a listen-to=src_55 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! audioconvert ! volume volume=2 ! rsaudioecho ! audioconvert ! voaacenc ! aacparse ! queue ! muxer.
gstd-client pipeline_create pipe_6_sink flvmux name=muxer ! rtmp2sink location=rtmp://127.0.0.1/live/chan-id-6 sync=false \
  interpipesrc name=interpipesrc6v listen-to=src_6 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! videoscale ! video/x-raw,width=960,height=480 ! videoconvert ! queue ! x264enc key-int-max=30 speed-preset=1 byte-stream=TRUE ! h264parse ! queue ! muxer. \
  interpipesrc name=interpipesrc6a listen-to=src_66 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! audioconvert ! volume volume=2 ! rsaudioecho ! audioconvert ! voaacenc ! aacparse ! queue ! muxer.
gstd-client pipeline_create pipe_7_sink flvmux name=muxer ! rtmp2sink location=rtmp://127.0.0.1/live/chan-id-7 sync=false \
  interpipesrc name=interpipesrc7v listen-to=src_7 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! videoscale ! video/x-raw,width=960,height=480 ! videoconvert ! queue ! x264enc key-int-max=30 speed-preset=1 byte-stream=TRUE ! h264parse ! queue ! muxer. \
  interpipesrc name=interpipesrc7a listen-to=src_77 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! audioconvert ! volume volume=2 ! rsaudioecho ! audioconvert ! voaacenc ! aacparse ! queue ! muxer.
gstd-client pipeline_create pipe_8_sink flvmux name=muxer ! rtmp2sink location=rtmp://127.0.0.1/live/chan-id-8 sync=false \
  interpipesrc name=interpipesrc8v listen-to=src_8 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! videoscale ! video/x-raw,width=960,height=480 ! videoconvert ! queue ! x264enc key-int-max=30 speed-preset=1 byte-stream=TRUE ! h264parse ! queue ! muxer. \
  interpipesrc name=interpipesrc8a listen-to=src_88 is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! audioconvert ! volume volume=2 ! rsaudioecho ! audioconvert ! voaacenc ! aacparse ! queue ! muxer.

echo -e "\n ====> Change to PLAYING STATE \n"
gstd-client pipeline_play pipe_1_src
gstd-client pipeline_play pipe_2_src
gstd-client pipeline_play pipe_3_src
gstd-client pipeline_play pipe_4_src
gstd-client pipeline_play pipe_5_src
gstd-client pipeline_play pipe_6_src
gstd-client pipeline_play pipe_7_src
gstd-client pipeline_play pipe_8_src


gstd-client pipeline_play pipe_1_sink
gstd-client pipeline_play pipe_2_sink
gstd-client pipeline_play pipe_3_sink
gstd-client pipeline_play pipe_4_sink
gstd-client pipeline_play pipe_5_sink
gstd-client pipeline_play pipe_6_sink
gstd-client pipeline_play pipe_7_sink
gstd-client pipeline_play pipe_8_sink

gstd-client pipeline_play pipe_pub_sink
gstd-client pipeline_play pipe_pre_sink

echo -e "\n ====> Every $switch seconds the sink_pipe will change the src_pipe that is listening to \n"
echo -e "\n ====> Start listening to scr_pipe_1 \n"
sleep $switch

# Start alternating the source pipeline being listened
while :
do
	gstd-client element_set pipe_pub_sink interpipesrcpv listen-to src_2
	gstd-client element_set pipe_pub_sink interpipesrcpa listen-to src_22
	gstd-client element_set pipe_pre_sink interpipesrcvv listen-to src_2
	gstd-client element_set pipe_pre_sink interpipesrcva listen-to src_22
	echo -e "\n ====> Change to listening to scr_pipe_2 \n"
	sleep $switch
	if [ $STOP -ne 0 ]
	then
		break
	fi
	
	gstd-client element_set pipe_pub_sink interpipesrcpv listen-to src_3
	gstd-client element_set pipe_pub_sink interpipesrcpa listen-to src_33
	gstd-client element_set pipe_pre_sink interpipesrcvv listen-to src_3
	gstd-client element_set pipe_pre_sink interpipesrcva listen-to src_33
	echo -e "\n ====> Change to listening to scr_pipe_3 \n"
	sleep $switch
	if [ $STOP -ne 0 ]
	then
		break
	fi

	gstd-client element_set pipe_pub_sink interpipesrcpv listen-to src_4
	gstd-client element_set pipe_pub_sink interpipesrcpa listen-to src_44
	gstd-client element_set pipe_pre_sink interpipesrcvv listen-to src_4
	gstd-client element_set pipe_pre_sink interpipesrcva listen-to src_44
	echo -e "\n ====> Change to listening to scr_pipe_4 \n"
	sleep $switch
	if [ $STOP -ne 0 ]
	then
		break
	fi

	gstd-client element_set pipe_pub_sink interpipesrcpv listen-to src_5
	gstd-client element_set pipe_pub_sink interpipesrcpa listen-to src_55
	gstd-client element_set pipe_pre_sink interpipesrcvv listen-to src_5
	gstd-client element_set pipe_pre_sink interpipesrcva listen-to src_55
	echo -e "\n ====> Change to listening to scr_pipe_5 \n"
	sleep $switch
	if [ $STOP -ne 0 ]
	then
		break
	fi

	gstd-client element_set pipe_pub_sink interpipesrcpv listen-to src_6
	gstd-client element_set pipe_pub_sink interpipesrcpa listen-to src_66
	gstd-client element_set pipe_pre_sink interpipesrcvv listen-to src_6
	gstd-client element_set pipe_pre_sink interpipesrcva listen-to src_66
	echo -e "\n ====> Change to listening to scr_pipe_6 \n"
	sleep $switch
	if [ $STOP -ne 0 ]
	then
		break
	fi

	gstd-client element_set pipe_pub_sink interpipesrcpv listen-to src_7
	gstd-client element_set pipe_pub_sink interpipesrcpa listen-to src_77
	gstd-client element_set pipe_pre_sink interpipesrcvv listen-to src_7
	gstd-client element_set pipe_pre_sink interpipesrcva listen-to src_77
	echo -e "\n ====> Change to listening to scr_pipe_7 \n"
	sleep $switch
	if [ $STOP -ne 0 ]
	then
		break
	fi

	gstd-client element_set pipe_pub_sink interpipesrcpv listen-to src_8
	gstd-client element_set pipe_pub_sink interpipesrcpa listen-to src_88
	gstd-client element_set pipe_pre_sink interpipesrcvv listen-to src_8
	gstd-client element_set pipe_pre_sink interpipesrcva listen-to src_88
	echo -e "\n ====> Change to listening to scr_pipe_8 \n"
	sleep $switch
	if [ $STOP -ne 0 ]
	then
		break
	fi

	gstd-client element_set pipe_pub_sink interpipesrcpv listen-to src_1
	gstd-client element_set pipe_pub_sink interpipesrcpa listen-to src_11
	gstd-client element_set pipe_pre_sink interpipesrcvv listen-to src_1
	gstd-client element_set pipe_pre_sink interpipesrcva listen-to src_11
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

gstd-client pipeline_delete pipe_1_sink
gstd-client pipeline_delete pipe_2_sink
gstd-client pipeline_delete pipe_3_sink
gstd-client pipeline_delete pipe_4_sink
gstd-client pipeline_delete pipe_5_sink
gstd-client pipeline_delete pipe_6_sink
gstd-client pipeline_delete pipe_7_sink
gstd-client pipeline_delete pipe_8_sink

gstd-client pipeline_delete pipe_pub_sink
gstd-client pipeline_delete pipe_pre_sink

echo -e "\n ====> CCTV Example Finished!!! \n"
