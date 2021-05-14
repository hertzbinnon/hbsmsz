//
#define __STREAM_IN__(videoname,audioname) "uridecodebin uri=%s name=source ! video/x-raw, framerate=30/1, width=3840, height=1920  ! queue ! interpipesink name=%s caps=video/x-raw,width=3840,height=1920 sync=false async=false  source. ! queue  ! interpipesink name=%s caps=audio/mpeg sync=false async=false"

#define __STREAM_TRANSMUXER_rtmp2udp() "rtmp2src location=%s ! flvdemux name=demuxer demuxer. ! h264parse config-interval=-1 ! queue min-threshold-time=0 max-size-buffers=0 max-size-bytes=0 max-size-time=0 ! mpegtsmux name=muxer alignment=7 ! queue min-threshold-time=0 max-size-buffers=0 max-size-bytes=0 max-size-time=0 ! udpsink host=%s port=%d demuxer. ! aacparse ! queue min-threshold-time=0 max-size-buffers=0 max-size-bytes=0 max-size-time=0 ! muxer."
/////////////////////////////////////////////////
#define __STREAM_TRANSMUXER_rtmp2tcp() "rtmp2src location=%s ! flvdemux name=demuxer demuxer. ! h264parse config-interval=-1 ! video/x-h264,stream-format=byte-stream,alignment=nal ! queue ! mpegtsmux name=muxer alignment=7 ! queue ! tcpserversink host=%s port=%d demuxer. ! aacparse ! queue ! muxer."

#define __STREAM_IN__TCP(videoname,audioname) "tcpclientsrc host=127.0.0.1 port=%d ! tsdemux name=source ! queue ! video/x-h264,stream-format=byte-stream,alignment=nal ! h264parse ! nvh264dec ! video/x-raw, width=3840, height=1920 ! queue ! interpipesink name=%s caps=video/x-raw,width=3840,height=1920 sync=false async=false source. ! avdec_aac ! queue ! interpipesink name=%s caps=audio/mpeg sync=false async=false"

#define __STREAM_RENDER__audio()

#define __STREAM_RENDER__videoto() "interpipesrc name=videorendersrc%d listen-to=%s is-live=true allow-renegotiation=true format=3 stream-sync=2 ! queue ! videoconvert ! textoverlay name=to ! interpipesink name=videorender%d caps=video/x-raw sync=false async=false"

#define __STREAM_RENDER__videogo() "interpipesrc name=videorendersrc%d listen-to=%s is-live=true allow-renegotiation=true format=3 stream-sync=2 ! queue ! videoconvert ! gdkpixbufoverlay name=go%d ! interpipesink name=videorender%d caps=video/x-raw sync=false async=false"

#define __STREAM_OUT__rtmp(videoname,audioname) "flvmux name=muxer ! rtmp2sink location=%s sync=false interpipesrc name=videosrc%s listen-to=%s is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! videoscale ! video/x-raw,width=960,height=480 ! videoconvert ! queue ! nvh264enc gop-size=30 preset=0 bitrate=1000 ! h264parse ! queue ! muxer. interpipesrc name=audiosrc%s listen-to=%s is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! audioconvert ! voaacenc ! aacparse ! queue ! muxer."

#define __STREAM_OUT__rtmp_pub(videoname,audioname) "flvmux name=muxer ! rtmp2sink location=%s sync=false interpipesrc name=videosrc%s listen-to=%s is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! videoconvert ! nvh264enc gop-size=30 preset=0 bitrate=2000 ! h264parse ! queue ! muxer. interpipesrc name=audiosrc%s listen-to=%s is-live=true allow-renegotiation=true format=3 stream-sync=2 max-latency=0 min-latency=0 ! queue ! audioconvert ! voaacenc ! aacparse ! queue ! muxer."


