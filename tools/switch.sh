#!/bin/bash
#!/bin/bash

wget -S -d --post-data "{\"cmd\":\"pull\",\"id\":1,\"url\":\"rtmp://10.9.119.38/live/ch1\"}" http://127.0.0.1:7777/postserver -O -
wget -S -d --post-data "{\"cmd\":\"pull\",\"id\":2,\"url\":\"rtmp://10.9.119.38/live/ch1\"}" http://127.0.0.1:7777/postserver -O -
wget -S -d --post-data "{\"cmd\":\"pull\",\"id\":3,\"url\":\"rtmp://10.9.119.38/live/ch1\"}" http://127.0.0.1:7777/postserver -O -
wget -S -d --post-data "{\"cmd\":\"pull\",\"id\":4,\"url\":\"rtmp://10.9.119.38/live/ch1\"}" http://127.0.0.1:7777/postserver -O -
wget -S -d --post-data "{\"cmd\":\"pull\",\"id\":5,\"url\":\"rtmp://10.9.119.38/live/ch1\"}" http://127.0.0.1:7777/postserver -O -
wget -S -d --post-data "{\"cmd\":\"pull\",\"id\":6,\"url\":\"rtmp://10.9.119.38/live/ch1\"}" http://127.0.0.1:7777/postserver -O -
wget -S -d --post-data "{\"cmd\":\"pull\",\"id\":7,\"url\":\"rtmp://10.9.119.38/live/ch1\"}" http://127.0.0.1:7777/postserver -O -
wget -S -d --post-data "{\"cmd\":\"pull\",\"id\":8,\"url\":\"rtmp://10.9.119.38/live/ch1\"}" http://127.0.0.1:7777/postserver -O -

wget -S -d --post-data "{\"cmd\":\"switch\",\"id\":1,\"video_id\":\"1\",\"audio_id\":\"1\",\"url\":\"udp://127.0.0.1:12341\"}" http://127.0.0.1:7777/postserver -O -
wget -S -d --post-data "{\"cmd\":\"publish\",\"id\":1,\"url\":\"rtmp://127.0.0.1:1935/live/publish\"}" http://127.0.0.1:7777/postserver -O -

for ((;;))
do
{
wget -S -d --post-data "{\"cmd\":\"switch\",\"id\":2,\"stream_id\":\"2\",\"video_id\":\"2\",\"audio_id\":\"2\",\"effect\":\"fade\",\"duration\":1}" http://$2:7777/postserver  -O /dev/null
sleep $1
wget -S -d --post-data "{\"cmd\":\"switch\",\"id\":3,\"stream_id\":\"3\",\"video_id\":\"3\",\"audio_id\":\"3\",\"effect\":\"fade\",\"duration\":1}" http://$2:7777/postserver  -O /dev/null
sleep $1
wget -S -d --post-data "{\"cmd\":\"switch\",\"id\":4,\"stream_id\":\"4\",\"video_id\":\"4\",\"audio_id\":\"4\",\"effect\":\"fade\",\"duration\":1}" http://$2:7777/postserver  -O /dev/null
sleep $1
wget -S -d --post-data "{\"cmd\":\"switch\",\"id\":5,\"stream_id\":\"5\",\"video_id\":\"5\",\"audio_id\":\"5\",\"effect\":\"fade\",\"duration\":1}" http://$2:7777/postserver  -O /dev/null
sleep $1
wget -S -d --post-data "{\"cmd\":\"switch\",\"id\":6,\"stream_id\":\"6\",\"video_id\":\"6\",\"audio_id\":\"6\",\"effect\":\"fade\",\"duration\":1}" http://$2:7777/postserver  -O /dev/null
sleep $1
wget -S -d --post-data "{\"cmd\":\"switch\",\"id\":7,\"stream_id\":\"7\",\"video_id\":\"7\",\"audio_id\":\"7\",\"effect\":\"fade\",\"duration\":1}" http://$2:7777/postserver  -O /dev/null
sleep $1
wget -S -d --post-data "{\"cmd\":\"switch\",\"id\":8,\"stream_id\":\"8\",\"video_id\":\"8\",\"audio_id\":\"8\",\"effect\":\"fade\",\"duration\":1}" http://$2:7777/postserver  -O /dev/null
sleep $1
wget -S -d --post-data "{\"cmd\":\"switch\",\"id\":1,\"stream_id\":\"1\",\"video_id\":\"1\",\"audio_id\":\"1\",\"effect\":\"fade\",\"duration\":1}" http://$2:7777/postserver  -O /dev/null
sleep $1
}
done
