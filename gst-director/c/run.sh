#!/bin/bash

killall -9 gstd-1.0
killall -9  hbsmsz
export GST_DEBUG=1
LD_LIBRARY_PATH=/home/hertz/sdb1/cerbero/build/dist/linux_x86_64/lib/x86_64-linux-gnu/:/home/hertz/sdb1/cerbero/build/dist/linux_x86_64/lib:/usr/local/lib64/ GST_PLUGIN_PATH=/home/hertz/sdb1/cerbero/build/dist/linux_x86_64/lib/gstreamer-1.0:/home/hertz/sdb1/cerbero/build/dist/linux_x86_64/lib/x86_64-linux-gnu/gstreamer-1.0 /tmp/gstd-1.0 -e 
sleep 1
LD_LIBRARY_PATH=/home/hertz/sdb1/cerbero/build/dist/linux_x86_64/lib/x86_64-linux-gnu/:/home/hertz/sdb1/cerbero/build/dist/linux_x86_64/lib:/usr/local/lib64/ /tmp/hbsmsz -p 8081 > /tmp/hbsmsz.log 2>&1 &
