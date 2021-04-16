wget -S -d --post-data "{\"cmd\":\"pull\",\"id\":1,\"url\":\"udp://127.0.0.1:12340\"}" http://127.0.0.1:7777/postserver -O -


wget -S -d --post-data "{\"cmd\":\"delete\",\"id\":1,\"url\":\"rtmp://127.0.0.1:1935/live/ch0\"}" http://127.0.0.1:7777/postserver -O -
wget -S -d --post-data "{\"cmd\":\"delete\",\"id\":2,\"url\":\"rtmp://127.0.0.1:1935/live/ch0\"}" http://127.0.0.1:7777/postserver -O -
wget -S -d --post-data "{\"cmd\":\"delete\",\"id\":3,\"url\":\"rtmp://127.0.0.1:1935/live/ch0\"}" http://127.0.0.1:7777/postserver -O -


wget -S -d --post-data "{\"cmd\":\"switch\",\"id\":1,\"video_id\":\"1\",\"audio_id\":\"1\",\"url\":\"udp://127.0.0.1:12341\"}" http://127.0.0.1:7777/postserver -O -


wget -S -d --post-data "{\"cmd\":\"publish\",\"id\":1,\"url\":\"rtmp://127.0.0.1:1935/live/publish\"}" http://127.0.0.1:7777/postserver -O -

wget -S -d --post-data "{\"cmd\":\"logo\",\"id\":0,\"stream_id\":\"0\",\"action\":\"add\",\"render_id\":0,\"logo_params\":[{\"pathname\":\"image.jpg\",\"rect\":{\"left\":100,\"top\":100,\"width\":100,\"height\":100},\"duration\":10}]}" http://127.0.0.1:7777/postserver

#
wget -S -d --post-data "{\"cmd\":\"pull\",\"id\":1,\"url\":\"rtmp://127.0.0.1/live/ch0\"}" http://127.0.0.1:7777/postserver -O -
wget -S -d --post-data "{\"cmd\":\"pull\",\"id\":2,\"url\":\"rtmp://127.0.0.1/live/ch1\"}" http://127.0.0.1:7777/postserver -O -
wget -S -d --post-data "{\"cmd\":\"pull\",\"id\":3,\"url\":\"rtmp://127.0.0.1/live/ch2\"}" http://127.0.0.1:7777/postserver -O -
wget -S -d --post-data "{\"cmd\":\"switch\",\"id\":1,\"video_id\":\"1\",\"audio_id\":\"1\",\"url\":\"udp://127.0.0.1:12341\"}" http://127.0.0.1:7777/postserver -O -
wget -S -d --post-data "{\"cmd\":\"publish\",\"id\":1,\"url\":\"rtmp://127.0.0.1:1935/live/publish\"}" http://127.0.0.1:7777/postserver -O -
wget -S -d --post-data "{\"cmd\":\"logo\",\"id\":0,\"stream_id\":\"0\",\"action\":\"add\",\"render_id\":0,\"logo_params\":[{\"pathname\":\"leaf.jpg\",\"rect\":{\"left\":50,\"top\":50,\"width\":100,\"height\":100},\"duration\":10}]}" http://127.0.0.1:7777/postserver -O -
wget -S -d --post-data "{\"cmd\":\"logo\",\"id\":0,\"stream_id\":\"0\",\"action\":\"add\",\"render_id\":1,\"logo_params\":[{\"pathname\":\"cat.jpg\",\"rect\":{\"left\":200,\"top\":200,\"width\":100,\"height\":100},\"duration\":10}]}" http://127.0.0.1:7777/postserver -O -
wget -S -d --post-data "{\"cmd\":\"logo\",\"id\":0,\"stream_id\":\"0\",\"action\":\"add\",\"render_id\":2,\"logo_params\":[{\"pathname\":\"puppy.jpg\",\"rect\":{\"left\":100,\"top\":100,\"width\":100,\"height\":100},\"duration\":10}]}" http://127.0.0.1:7777/postserver -O -
wget -S -d --post-data "{\"cmd\":\"logo\",\"id\":0,\"stream_id\":\"0\",\"action\":\"update\",\"render_id\":2,\"logo_params\":[{\"pathname\":\"puppy.jpg\",\"rect\":{\"left\":200,\"top\":0,\"width\":100,\"height\":100},\"duration\":10}]}" http://127.0.0.1:7777/postserver -O -
wget -S -d --post-data "{\"cmd\":\"logo\",\"id\":0,\"stream_id\":\"0\",\"action\":\"update\",\"render_id\":2,\"logo_params\":[{\"pathname\":\"puppy.jpg\",\"rect\":{\"left\":200,\"top\":200,\"width\":100,\"height\":100},\"duration\":10}]}" http://127.0.0.1:7777/postserver -O -
wget -S -d --post-data "{\"cmd\":\"logo\",\"id\":0,\"stream_id\":\"0\",\"action\":\"update\",\"render_id\":1,\"logo_params\":[{\"pathname\":\"cat.jpg\",\"rect\":{\"left\":200,\"top\":200,\"width\":100,\"height\":100},\"duration\":10}]}" http://127.0.0.1:7777/postserver -O -
wget -S -d --post-data "{\"cmd\":\"logo\",\"id\":0,\"stream_id\":\"0\",\"action\":\"update\",\"render_id\":1,\"logo_params\":[{\"pathname\":\"cat.jpg\",\"rect\":{\"left\":100,\"top\":100,\"width\":100,\"height\":100},\"duration\":10}]}" http://127.0.0.1:7777/postserver -O -
wget -S -d --post-data "{\"cmd\":\"logo\",\"id\":0,\"stream_id\":\"0\",\"action\":\"update\",\"render_id\":1,\"logo_params\":[{\"pathname\":\"cat.jpg\",\"rect\":{\"left\":100,\"top\":100,\"width\":100,\"height\":100},\"duration\":10}]}" http://127.0.0.1:7777/postserver -O -
wget -S -d --post-data "{\"cmd\":\"logo\",\"id\":0,\"stream_id\":\"0\",\"action\":\"update\",\"render_id\":2,\"logo_params\":[{\"pathname\":\"puppy.jpg\",\"rect\":{\"left\":250,\"top\":100,\"width\":100,\"height\":100},\"duration\":10}]}" http://127.0.0.1:7777/postserver -O -
wget -S -d --post-data "{\"cmd\":\"switch\",\"id\":1,\"video_id\":\"1\",\"audio_id\":\"1\",\"url\":\"udp://127.0.0.1:12341\"}" http://127.0.0.1:7777/postserver -O -
wget -S -d --post-data "{\"cmd\":\"switch\",\"id\":2,\"video_id\":\"2\",\"audio_id\":\"2\",\"url\":\"udp://127.0.0.1:12341\"}" http://127.0.0.1:7777/postserver -O -
wget -S -d --post-data "{\"cmd\":\"switch\",\"id\":1,\"video_id\":\"1\",\"audio_id\":\"1\",\"url\":\"udp://127.0.0.1:12341\"}" http://127.0.0.1:7777/postserver -O -
wget -S -d --post-data "{\"cmd\":\"switch\",\"id\":2,\"video_id\":\"2\",\"audio_id\":\"2\",\"url\":\"udp://127.0.0.1:12341\"}" http://127.0.0.1:7777/postserver -O -
wget -S -d --post-data "{\"cmd\":\"switch\",\"id\":1,\"video_id\":\"1\",\"audio_id\":\"1\",\"url\":\"udp://127.0.0.1:12341\"}" http://127.0.0.1:7777/postserver -O -
wget -S -d --post-data "{\"cmd\":\"volume\",\"id\":1,\"vol\":0.2,\"audio_id\":\"2\"}" http://127.0.0.1:7777/postserver -O -



# raw request
wget -S -d --post-data "name=1&description=videotestsrc ! ximagesink" http://127.0.0.1:5001/pipelines -O -
wget --method=PUT --body-data="name=null" http://127.0.0.1:5001/pipelines/1/state -O - # STOP
wget --method=PUT --body-data="name=playing" http://127.0.0.1:5001/pipelines/1/state -O -
wget --method=DELETE --body-data="name=1" http://127.0.0.1:5001/pipelines -O -

