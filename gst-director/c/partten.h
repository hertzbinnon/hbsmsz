#define __STREAM_IN__(videoname,audioname) "uridecodebin uri=%s name=source ! video/x-raw, framerate=30/1, width=352, height=288, format=Y444_10LE ! queue ! interpipesink name=%s caps=video/x-raw,width=352,height=288,framerate=30/1 sync=false async=false  source. ! queue ! audioconvert ! voaacenc ! aacparse ! queue ! interpipesink name=%s caps=audio/mpeg sync=false async=false"

#define __STREAM_RENDER__audio()

#define __STREAM_RENDER__video()

#define __STREAM_OUT__rtmp(videoname,audioname) "flvmux name=muxer ! rtmp2sink location=%s sync=false interpipesrc name=videosrc%s listen-to=%s is-live=true allow-renegotiation=true format=3 stream-sync=2 ! queue ! videoconvert ! x264enc key-int-max=30 speed-preset=1 ! h264parse !  muxer. interpipesrc name=audiosrc%s listen-to=%s is-live=true allow-renegotiation=true format=3 stream-sync=2 ! queue ! aacparse ! muxer."
