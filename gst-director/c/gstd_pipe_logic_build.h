#include <glib.h>
#define DES_STR_LENGTH 1024

enum GSTD_COMMAND{
  CREATE = 0x01,
  PLAY = 0x02,
  STOP = 0x04,
  DELETE = 0x08,
  SET_OPT = 0x10,
};

typedef struct _OptionSet{
  gchar ele_name[256];
  gchar property[256];
  gchar property_value[256];
  gsize s;
}OptionSet;

typedef struct _Argment{
  gchar src_uri[1024];
  gchar out_uri[1024];
  gchar prev_uri[1024];
  gchar push_uri[1024];
  gchar atrack_id[1024];
  gchar vtrack_id[1024];
  gchar stream_id[1024];
  OptionSet sets[1024];
} Argment ;

typedef struct _PipelineDescribe{

   gchar pipename[1024];
   enum GSTD_COMMAND  cmd;
   gchar         __str[8*DES_STR_LENGTH];
   Argment       __args;

} PipelineDescribe;

gchar* message_process(const gchar* msg);
