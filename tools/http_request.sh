wget -S -d --post-data "{\"cmd\":\"pull\",\"id\":1,\"url\":\"udp://192.168.0.134:12340\"}" http://192.168.0.134:8888/postserver -O -


wget -S -d --post-data "{\"cmd\":\"delete\",\"id\":2,\"url\":\"rtmp://192.168.0.134:1935/live/ch0\"}" http://192.168.0.134:8888/postserver -O -


wget -S -d --post-data "{\"cmd\":\"switch\",\"id\":1,\"video_id\":\"1\",\"audio_id\":\"1\",\"url\":\"udp://192.168.0.134:12341\"}" http://192.168.0.134:8888/postserver -O -


wget -S -d --post-data "{\"cmd\":\"publish\",\"id\":1,\"url\":\"rtmp://192.168.0.134:1935/live/publish\"}" http://192.168.0.134:8888/postserver -O -


# raw request
wget -S -d --post-data "name=1&description=videotestsrc ! ximagesink" http://127.0.0.1:5001/pipelines -O -
wget --method=PUT --body-data="name=null" http://127.0.0.1:5001/pipelines/1/state -O - # STOP
wget --method=PUT --body-data="name=playing" http://127.0.0.1:5001/pipelines/1/state -O -
wget --method=DELETE --body-data="name=1" http://127.0.0.1:5001/pipelines -O -
