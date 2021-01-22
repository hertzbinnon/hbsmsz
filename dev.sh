#!/bin/bash
make install
../../Install/sbin/nginx -s stop
../../Install/sbin/nginx
killall gstd -9
gstd -e
