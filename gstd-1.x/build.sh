#!/bin/bash
#~/sdb1/cerbero/cerbero-uninstalled shell
# 8b1fb13d78d0c6a25e94eb8aa027db6837d4cd41 --> commit
export GST_PLUGIN_PATH=/home/hertz/sdb1/cerbero/build/dist/linux_x86_64/lib/gstreamer-1.0:/home/hertz/sdb1/cerbero/build/dist/linux_x86_64/lib/x86_64-linux-gnu/gstreamer-1.0
export PKG_CONFIG_PATH=/home/hertz/sdb1/cerbero/build/dist/linux_x86_64/lib/pkgconfig:/home/hertz/sdb1/cerbero/build/dist/linux_x86_64/lib/x86_64-linux-gnu/pkgconfig/:/usr/lib/x86_64-linux-gnu/pkgconfig
export PYTHONPATH=/home/hertz/sdb1/cerbero/build/build-tools/lib/python3.7/site-packages:/home/hertz/sdb1/cerbero/build/build-tools/lib/python3.7/site-packages/meson-0.54.0-py3.7.egg:$PYTHONPATH

export PATH=/home/hertz/sdb1/cerbero/build/build-tools/bin/:/home/hertz/sdb1/cerbero/build/dist/linux_x86_64/bin:$PATH
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/usr/lib/x86_64-linux-gnu/pkgconfig
export LD_LIBRARY_PATH=/home/hertz/sdb1/cerbero/build/dist/linux_x86_64/lib/x86_64-linux-gnu/:/home/hertz/sdb1/cerbero/build/dist/linux_x86_64/lib
