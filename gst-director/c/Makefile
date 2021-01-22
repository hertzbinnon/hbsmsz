#include release/vrsmsz/Expiration
CFLAGS ?= -O2 -g -Wall -I.
LDFLAGS ?=

GST_CFLAGS = $(shell pkg-config --cflags gstreamer-1.0)
GST_LDFLAGS = $(shell pkg-config --libs gstreamer-1.0)

GIO_CFLAGS = $(shell pkg-config --cflags gio-2.0)
GIO_LDFLAGS = $(shell pkg-config --libs gio-2.0)

GSOUP_CFLAGS=$(shell pkg-config  --cflags libsoup-2.4)
GSOUP_LDFLAGS=$(shell pkg-config  --libs libsoup-2.4)

GST_CONTROLLER_CFLAGS = $(shell pkg-config --cflags gstreamer-controller-1.0)
GST_CONTROLLER_LDFLAGS = $(shell pkg-config --libs gstreamer-controller-1.0)

GLIB_JSON_CFLAGS = $(shell pkg-config --cflags json-glib-1.0)
GLIB_JSON_LDFLAGS = $(shell pkg-config --libs json-glib-1.0)

NANO_CFLAGS = $(shell pkg-config --cflags libcsoap)
NANO_LDFLAGS = $(shell pkg-config --libs libcsoap)

GSTDC_CFLAGS = $(shell pkg-config --cflags gstc-1.0)
GSTDC_LDFLAGS = $(shell pkg-config --libs  gstc-1.0)

all: hbsmsz #addstream test-effect-switch doc-effect-switch switch-src-element crossfade comp-switch-dynamic interpipe

clean:
	rm -f VRsmsz *.o addstream test-effect-switch doc-effect-switch switch-src-element crossfade comp-switch-dynamic interpipe 


#httpd.o : httpd.c httpd.h
#	$(CC) -c  httpd.c $(CFLAGS) $(GST_CFLAGS) $(GSOUP_CFLAGS) $(LDFLAGS) $(GST_LDFLAGS)

simple-httpd.o : simple-httpd.c 
	$(CC) -c  $^ $(CFLAGS) $(GST_CFLAGS) $(NANO_CFLAGS) $(GSOUP_CFLAGS)

gstdc.o : gstdc.c 
	$(CC) -c  $^ $(CFLAGS) $(GST_CFLAGS) $(NANO_CFLAGS) $(GSOUP_CFLAGS) $(GLIB_JSON_CFLAGS)


hbsmsz  : simple-httpd.o gstdc.o
	$(CC) -o $@ $^ $(CFLAGS) $(GST_CFLAGS) $(GLIB_JSON_LDFLAGS)  $(LDFLAGS) $(GST_LDFLAGS) $(GSOUP_LDFLAGS) $(GSTDC_LDFLAGS)

