#!/bin/sh

cd nginx
echo "configure start ..."
 ./auto/configure \
--prefix=/home/hertz/sdb1/hbsmsz/Install \
--with-http_dav_module \
--with-http_flv_module \
--with-http_stub_status_module \
--without-http_scgi_module \
--without-http_uwsgi_module \
--without-http_gzip_module \
--without-http_ssi_module \
--without-http_memcached_module \
--without-http_empty_gif_module \
--without-mail_pop3_module \
--without-mail_imap_module \
--without-mail_smtp_module \
--with-stream_ssl_module \
--add-module=../nginx-gstd-control-module \
--add-module=../ngx_http_echo_module \
--with-debug
 echo "configure end!"
make install
