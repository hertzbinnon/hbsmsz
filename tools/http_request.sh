wget -S -d --post-data "{\"cmd\":\"pull\",\"id\":1,\"url\":\"udp://192.168.0.134:12340\"}" http://192.168.0.134:8888/postserver -O -


wget -S -d --post-data "{\"cmd\":\"delete\",\"id\":2,\"url\":\"rtmp://192.168.0.134:1935/live/ch0\"}" http://192.168.0.134:8888/postserver -O -


wget -S -d --post-data "{\"cmd\":\"switch\",\"id\":1,\"video_id\":\"1\",\"audio_id\":\"1\",\"url\":\"udp://192.168.0.134:12341\"}" http://192.168.0.134:8888/postserver -O -


wget -S -d --post-data "{\"cmd\":\"publish\",\"id\":1,\"url\":\"rtmp://192.168.0.134:1935/live/publish\"}" http://192.168.0.134:8888/postserver -O -
