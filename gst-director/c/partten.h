//
#define __STREAM_IN__(videoname,audioname) "uridecodebin uri=%s name=source ! video/x-raw, framerate=30/1, width=3840, height=1920  ! queue ! interpipesink name=%s caps=video/x-raw,width=3840,height=1920 sync=false async=false  source. ! queue  ! interpipesink name=%s caps=audio/mpeg sync=false async=false"

#define __STREAM_TRANSMUXER_rtmp2udp() "rtmp2src location=%s timeout=30 ! flvdemux name=demuxer demuxer. ! h264parse config-interval=-1 ! queue min-threshold-time=0 max-size-buffers=0 max-size-bytes=0 max-size-time=0 ! mpegtsmux name=muxer alignment=7 ! queue min-threshold-time=0 max-size-buffers=0 max-size-bytes=0 max-size-time=0 ! udpsink host=%s port=%d demuxer. ! aacparse ! queue min-threshold-time=0 max-size-buffers=0 max-size-bytes=0 max-size-time=0 ! muxer."
/////////////////////////////////////////////////
#define __STREAM_TRANSMUXER_rtmp2tcp() "rtmp2src location=%s timeout=30 ! flvdemux name=demuxer demuxer. ! h264parse config-interval=-1 ! queue ! mpegtsmux name=muxer alignment=7 ! queue  name=delayer min-threshold-time=%lld max-size-buffers=0 max-size-bytes=0 max-size-time=30000000000 ! tcpserversink host=%s port=%d demuxer. ! aacparse ! queue ! muxer."

#define __STREAM_TRANSMUXER_rtmp2tcp_8k() "rtmp2src location=%s timeout=30 ! flvdemux name=demuxer demuxer. ! h265parse config-interval=-1 ! queue ! mpegtsmux name=muxer alignment=7 ! queue  name=delayer min-threshold-time=%lld max-size-buffers=0 max-size-bytes=0 max-size-time=30000000000 ! tcpserversink host=%s port=%d demuxer. ! aacparse ! queue ! muxer."

#define __STREAM_IN__TCP_TEST(videoname,audioname) "tcpclientsrc host=127.0.0.1 port=%d ! tsdemux name=source ! queue ! video/x-h264,stream-format=byte-stream,alignment=nal ! h264parse ! nvh264dec !  queue ! clockoverlay text=\"channel %d\" ! videorate max-rate=25 average-period=100000000 ! video/x-raw, width=3840, height=1920 ! queue ! interpipesink name=%s caps=video/x-raw,width=3840,height=1920 sync=false async=false source. ! queue ! avdec_aac ! audioconvert ! volume name=volume volume=1 ! rsaudioecho ! audioconvert ! queue ! interpipesink name=%s caps=audio/mpeg sync=false async=false"

#define __STREAM_IN__TCP(videoname,audioname) "tcpclientsrc host=127.0.0.1 port=%d ! tsdemux name=source ! queue ! video/x-h264,stream-format=byte-stream,alignment=nal ! h264parse ! nvh264dec !  queue ! videobalance ! queue ! interpipesink name=%s caps=video/x-raw,width=3840,height=1920 sync=false async=false source. ! queue ! avdec_aac ! audioconvert ! volume name=volume volume=1 ! audioconvert ! queue ! interpipesink name=%s caps=audio/mpeg sync=false async=false"

#define __STREAM_IN__TCP_8k(videoname,audioname) "tcpclientsrc host=127.0.0.1 port=%d ! tsdemux name=source ! queue ! video/x-h265,stream-format=byte-stream,alignment=nal ! h265parse ! nvh265dec !  queue ! videobalance ! queue ! interpipesink name=%s caps=video/x-raw,width=7680,height=3840 sync=false async=false source. ! queue ! avdec_aac ! audioconvert ! volume name=volume volume=1 ! audioconvert ! queue ! interpipesink name=%s caps=audio/mpeg sync=false async=false"

#define __STREAM_RENDER__audio()

#define __STREAM_RENDER__videoto() "interpipesrc name=videorendersrc%d listen-to=%s is-live=true allow-renegotiation=true format=3 stream-sync=2 ! queue ! videoconvert ! textoverlay name=to ! interpipesink name=videorender%d caps=video/x-raw sync=false async=false"

#define __STREAM_RENDER__videogo() "interpipesrc name=videorendersrc%d listen-to=%s is-live=true allow-renegotiation=true format=3 stream-sync=2 ! queue ! videoconvert ! gdkpixbufoverlay name=go%d location=\"/var/local/vrsmsz/image.jpg\" ! interpipesink name=videorender%d caps=video/x-raw sync=false async=false"

#define __STREAM_RENDER_compositor() "compositor name=comp sink_1::alpha=0.5 ! interpipesink name=videocompositorsink caps=video/x-raw sync=false async=false interpipesrc name=videocompositorsrc0 listen-to=%s is-live=true allow-renegotiation=true format=3 stream-sync=2 ! queue ! videoconvert ! comp.sink_0 interpipesrc name=videocompositorsrc1 listen-to=%s is-live=true allow-renegotiation=true format=3 stream-sync=2 ! queue ! videoconvert ! comp.sink_1"

#define __STREAM_OUT__rtmp(videoname,audioname) "flvmux name=muxer encoder=\"vrsmsz\" metadatacreator=\"vrsmsz\" latency=1000000000 streamable=true ! rtmp2sink location=%s sync=false interpipesrc name=videosrc%s listen-to=%s is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! videoscale ! video/x-raw,width=960,height=480 ! queue ! videoconvert ! queue ! nvh264enc gop-size=30 bitrate=%d ! h264parse ! queue ! muxer. interpipesrc name=audiosrc%s listen-to=%s is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! audioconvert ! voaacenc ! aacparse ! queue ! muxer."

#define __STREAM_OUT__rtmp_8k(videoname,audioname) "flvmux name=muxer encoder=\"vrsmsz\" metadatacreator=\"vrsmsz\" latency=1000000000 streamable=true ! rtmp2sink location=%s sync=false interpipesrc name=videosrc%s listen-to=%s is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! videoscale ! video/x-raw,width=960,height=480 ! queue ! videoconvert ! queue ! nvh264enc gop-size=30 bitrate=%d ! h264parse ! queue ! muxer. interpipesrc name=audiosrc%s listen-to=%s is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! audioconvert ! voaacenc ! aacparse ! queue ! muxer."

#define __STREAM_OUT__rtmp_pub(videoname,audioname) "flvmux name=muxer encoder=\"vrsmsz\" metadatacreator=\"vrsmsz\" latency=1000000000 streamable=true ! rtmp2sink location=%s sync=false interpipesrc name=videosrc%s listen-to=%s is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! videoconvert ! nvh264enc gop-size=30 preset=0 bitrate=%d ! h264parse ! queue ! muxer. interpipesrc name=audiosrc%s listen-to=%s is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! audioconvert ! voaacenc ! aacparse ! queue ! muxer."

#define __STREAM_OUT__rtmp_pub_8k(videoname,audioname) "flvmux name=muxer encoder=\"vrsmsz\" metadatacreator=\"vrsmsz\" latency=3000000000 streamable=true ! rtmp2sink location=%s sync=false interpipesrc name=videosrc%s listen-to=%s is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! videorate ! video/x-raw,framerate=25/1 ! queue ! videoconvert ! queue ! nvh265enc gop-size=25 preset=3 bitrate=%d ! h265parse ! queue ! muxer. interpipesrc name=audiosrc%s listen-to=%s is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! audioconvert ! voaacenc ! aacparse ! queue ! muxer."

