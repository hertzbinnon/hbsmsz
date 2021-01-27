#include <gstd_pipe_logic_build.h>
#include <json-glib/json-glib.h>
#include "libgstc.h"
#include "partten.h"
#define MEDIA_PATH "/tmp"
GstClient *__client = NULL;

GstClient *
connect_gstd ()
{
  //GstClient *client;
  GstcStatus ret;
  const char *address = "127.0.0.1";
  const unsigned int port = 5000;
  const long wait_time = -1;
  const int keep_open = 1;

  if (!__client) {
    ret = gstc_client_new (address, port, wait_time, keep_open, &__client);
    if (GSTC_OK != ret) {
      g_print ("Connected Daemon Error !!! \n");
    }
  }
  return __client;
}

gint
is_exist (gchar * pipename)
{
  GstcStatus ret;
  GstClient *client = connect_gstd ();
  gchar **pipelist;
  gint len;
  ret = gstc_pipeline_list (client, &pipelist, &len);
  if (ret != GSTC_OK)
    return 0;

  for (int i = 0; i < len; i++) {
    if (!strcmp (pipename, pipelist[i])) {
      g_print ("Pipeline exist!\n");
      return 1;
    }
  }

//  gstc_client_free (client);
  return 0;
}

GstcStatus
get_property_value (const gchar * pname, const gchar * element,
    const gchar * property, gchar * value)
{
  GstClient *client = connect_gstd ();
  GstcStatus ret;

  ret = gstc_element_get (client, pname, element, property, "%s", value);
  if (GSTC_OK == ret) {
    g_print ("Get value %s = %s!\n", property, value);
  } else {
    g_print ("Error get value\n");
  }
  //gstc_client_free (client);
  return ret;
}

void
create_gstd (GstClient * client, PipelineDescribe * pd)
{
  GstcStatus ret;
  if (is_exist (pd->pipename)) {
    return;
  }
  ret = gstc_pipeline_create (client, pd->pipename, pd->__str);
  if (GSTC_OK == ret) {
    g_print ("Pipeline created successfully!\n");
  } else {
    g_print ("Error creating pipeline:%s-->%s\n", pd->pipename, pd->__str);
  }
}

void
play_gstd (GstClient * client, PipelineDescribe * pd)
{
  GstcStatus ret;
  ret = gstc_pipeline_play (client, pd->pipename);
  if (GSTC_OK == ret) {
    g_print ("Pipeline set to playing!\n");
  } else {
    g_print ("Unable to play pipeline: \n");
  }
}

void
stop_gstd (GstClient * client, PipelineDescribe * pd)
{
  GstcStatus ret;
  ret = gstc_pipeline_pause (client, pd->pipename);
  if (GSTC_OK == ret) {
    g_print ("Pipeline set to stop !\n");
  } else {
    g_print ("Unable to stop pipeline: \n");
  }
}

void
delete_gstd (GstClient * client, PipelineDescribe * pd)
{
  GstcStatus ret;
  ret = gstc_pipeline_delete (client, pd->pipename);
  if (GSTC_OK == ret) {
    g_print ("Pipeline set to delete !\n");
  } else {
    g_print ("Unable to delete pipeline: \n");
  }
}

//element_set pipe_4_sink interpipesrc1 listen-to src_2
void
set_gstd (GstClient * client, PipelineDescribe * pd)
{
  GstcStatus ret;
  //GstElement** ele =NULL;
#if 1
  char **ele = NULL;
  gint len;

  ret = gstc_pipeline_list_elements (client, pd->pipename, &ele, &len);
  if( ret != GSTC_OK)
    {g_print("list error\n");}
  for (int i = 0; i < len; i++) {
    g_print ("element name %s\n", ele[i]);
  }
#endif
  for (int i = 0; i < 1024; i++) {
    if (pd->__args.sets[i].s == 1) {
      ret =
          gstc_element_set (client, pd->pipename, pd->__args.sets[i].ele_name,
          pd->__args.sets[i].property, "%s", pd->__args.sets[i].property_value);
      if (GSTC_OK == ret) {
        g_print ("Pipeline set opt %s %s %s %s\n", pd->pipename,
            pd->__args.sets[i].ele_name, pd->__args.sets[i].property,
            pd->__args.sets[i].property_value);
      } else {
        g_print ("Unable to set pipeline: \n");
      }
    } else
      break;
  }
}

void
convert_process (PipelineDescribe * pd)
{
  GstClient *client = connect_gstd ();
  if (pd->cmd & CREATE) {
    g_print ("CREATE \n");
    create_gstd (client, pd);
  }
  if (pd->cmd & PLAY) {
    g_print ("PLAY\n");
    play_gstd (client, pd);
  }

  if (pd->cmd & STOP) {
    g_print ("STOP\n");
    stop_gstd (client, pd);
  }

  if (pd->cmd & DELETE) {
    g_print ("DELETE\n");
    delete_gstd (client, pd);
  }

  if (pd->cmd & SET_OPT) {
    g_print ("SET_OPT\n");
    set_gstd (client, pd);
  }
//free_client:
//  gstc_client_free (client);
}

gchar *
message_process (const gchar * msg)
{
  GError *error = NULL;
  JsonObject *obj = NULL;
  JsonNode *root = NULL;
  const gchar *ret = NULL, *cmd = NULL;
  PipelineDescribe *pd = NULL;
  gchar vn[1024], an[1024];
  int id = -2;

  pd = g_malloc0 (sizeof (PipelineDescribe));
  memset (pd, 0, sizeof (*pd));

  JsonParser *parser = json_parser_new ();
  json_parser_load_from_data (parser, msg, strlen (msg), &error);
  if (error) {
    g_print ("Unable to parse %s", msg);
    g_error_free (error);
    g_object_unref (parser);
    return NULL;
  }

  root = json_parser_get_root (parser);
  if (!root)
    g_error ("get root node failed\n");
  obj = json_node_get_object (root);
  cmd = json_object_get_string_member (obj, "cmd");
  if (!cmd)
    return NULL;

  id = json_object_get_int_member (obj, "id");
  sprintf (pd->pipename, "%d", id);

  if (!strcmp (cmd, "pull")) {
    pd->cmd = CREATE | PLAY;
    ret = json_object_get_string_member (obj, "url");
    if (!ret)
      return NULL;
    memcpy (pd->__args.src_uri, ret, strlen (ret) + 1);
    sprintf (vn, "vtrack-id-%d", id);
    sprintf (an, "atrack-id-%d", id);
    sprintf (pd->__str, __STREAM_IN__ (atrack, vtrack), pd->__args.src_uri, vn,
        an);

    g_print ("pull-- %s \n", pd->__str);

    convert_process (pd);
    sprintf (pd->pipename, "channel-id-%d", id);
    sprintf (pd->__args.out_uri, "rtmp://192.168.0.134/live/chan-id-%d", id);
    sprintf (pd->__str, __STREAM_OUT__rtmp (atrack, vtrack), pd->__args.out_uri,
        pd->pipename, vn, pd->pipename, an);
    g_print ("pull-- %s \n", pd->__str);
#if 1
  } else if (!strcmp (cmd, "logo")) {
    GstcStatus r;
    gint iret = -1;
    gint rid = json_object_get_int_member (obj,"render_id");
    r = get_property_value ("preview", "videosrcpreview", "listen-to", vn);
    if (r != GSTC_OK) {
      return NULL;
    }
    sprintf (pd->pipename, "videorender-%d", rid);
    ret = json_object_get_string_member (obj,"action");
    if(!strcmp(ret, "add")){
      if (is_exist (pd->pipename)) {
	g_print("pipeline: %s is exist\n", pd->pipename);
	return NULL;
      }
      pd->cmd = CREATE | PLAY | SET_OPT;
      sprintf (pd->__str, __STREAM_RENDER__videogo(), rid, vn, rid, rid);
      g_print("logo-- %s\n",pd->__str);

      sprintf (pd->__args.sets[0].ele_name, "go%d", rid);
      sprintf (pd->__args.sets[0].property, "%s", "location");
      JsonArray  *array = json_object_get_array_member(obj, "logo_params");
      JsonObject *sub_obj = json_array_get_object_element(array, 0);
      ret =  json_object_get_string_member (sub_obj,"pathname");
      sprintf (pd->__args.sets[0].property_value, MEDIA_PATH"/%s", ret);
      pd->__args.sets[0].s = 1;
      
      JsonObject *sub_obj1 = json_object_get_object_member (sub_obj,"rect");
      iret =  json_object_get_int_member (sub_obj1,"left");
      sprintf (pd->__args.sets[1].ele_name, "go%d", rid);
      sprintf (pd->__args.sets[1].property, "%s", "offset-x");
      sprintf (pd->__args.sets[1].property_value, "%d", iret);
      pd->__args.sets[1].s = 1;

      iret =  json_object_get_int_member (sub_obj1,"top");
      sprintf (pd->__args.sets[2].ele_name, "go%d", rid);
      sprintf (pd->__args.sets[2].property, "%s", "offset-y");
      sprintf (pd->__args.sets[2].property_value, "%d", iret);
      pd->__args.sets[2].s = 1;
      convert_process (pd);


      //ret =  json_object_get_int_member (sub_obj1,"width");
      //ret =  json_object_get_int_member (sub_obj1,"height");
      pd->cmd = SET_OPT;
      memset(pd->__args.sets,0,sizeof(pd->__args.sets));
      sprintf (pd->pipename, "%s","preview");
      sprintf (pd->__args.sets[0].ele_name, "%spreview", "videosrc");
      sprintf (pd->__args.sets[0].property, "%s", "listen-to");
      sprintf (pd->__args.sets[0].property_value, "videorender%d", rid);
      pd->__args.sets[0].s = 1;
      convert_process (pd);

      memset(pd->__args.sets,0,sizeof(pd->__args.sets));
      //g_print("%d %d %d\n",sizeof(*pd->__args.sets),sizeof(pd->__args.sets),sizeof(OptionSet));
      sprintf (pd->pipename, "%s", "publish");
      sprintf (pd->__args.sets[0].ele_name, "%spublish", "videosrc");
      sprintf (pd->__args.sets[0].property, "%s", "listen-to");
      sprintf (pd->__args.sets[0].property_value, "videorender%d", rid);
      pd->__args.sets[0].s = 1;

    }else if(!strcmp(ret, "update")){
      if (!is_exist (pd->pipename)) {
	g_print("pipeline: %s is not exist\n", pd->pipename);
	return NULL;
      }
      pd->cmd = SET_OPT;
      sprintf (pd->__args.sets[0].ele_name, "go%d", rid);
      sprintf (pd->__args.sets[0].property, "%s", "location");
      JsonArray  *array = json_object_get_array_member(obj, "logo_params");
      JsonObject *sub_obj = json_array_get_object_element(array, 0);
      ret =  json_object_get_string_member (sub_obj,"pathname");
      sprintf (pd->__args.sets[0].property_value, MEDIA_PATH"/%s", ret);
      pd->__args.sets[0].s = 1;
      
      JsonObject *sub_obj1 = json_object_get_object_member (sub_obj,"rect");
      iret =  json_object_get_int_member (sub_obj1,"left");
      sprintf (pd->__args.sets[1].ele_name, "go%d", rid);
      sprintf (pd->__args.sets[1].property, "%s", "offset-x");
      sprintf (pd->__args.sets[1].property_value, "%d", iret);
      pd->__args.sets[1].s = 1;

      iret =  json_object_get_int_member (sub_obj1,"top");
      sprintf (pd->__args.sets[2].ele_name, "go%d", rid);
      sprintf (pd->__args.sets[2].property, "%s", "offset-y");
      sprintf (pd->__args.sets[2].property_value, "%d", iret);
      pd->__args.sets[2].s = 1;

    }else if(!strcmp(ret, "delete")){

    }else{

    }
#endif
  } else if (!strcmp (cmd, "switch")) {
    int a, v;
    g_print ("switch \n");
    pd->cmd = CREATE | PLAY;
    sprintf (pd->pipename, "%s", "preview");
    sprintf (pd->__args.prev_uri, "%s", "rtmp://192.168.0.134/live/preview");
    sprintf (vn, "vtrack-id-%d", id);
    sprintf (an, "atrack-id-%d", id);
    sprintf (pd->__str, __STREAM_OUT__rtmp (atrack, vtrack),
        pd->__args.prev_uri, pd->pipename, vn, pd->pipename, an);
    convert_process (pd);

    pd->cmd = SET_OPT;
    ret = json_object_get_string_member (obj, "video_id");
    if (!ret)
      return NULL;
    v = atoi (ret);
    if (v != -1) {
      sprintf (pd->__args.sets[0].ele_name, "%spreview", "videosrc");
      sprintf (pd->__args.sets[0].property, "%s", "listen-to");
      sprintf (pd->__args.sets[0].property_value, "vtrack-id-%s", ret);
      pd->__args.sets[0].s = 1;
    }
    ret = json_object_get_string_member (obj, "audio_id");
    if (!ret)
      return NULL;
    a = atoi (ret);
    if (a != -1) {
      sprintf (pd->__args.sets[1].ele_name, "%spreview", "audiosrc");
      sprintf (pd->__args.sets[1].property, "%s", "listen-to");
      sprintf (pd->__args.sets[1].property_value, "atrack-id-%s", ret);
      pd->__args.sets[1].s = 1;
    }

    if (is_exist ("publish")) {
      convert_process (pd);
      if (a != -1) {
        sprintf (pd->__args.sets[1].ele_name, "%spublish", "audiosrc");
      }
      if (v != -1) {
        sprintf (pd->__args.sets[0].ele_name, "%spublish", "videosrc");
      }
      sprintf (pd->pipename, "%s", "publish");
    }

  } else if (!strcmp (cmd, "publish")) {
    GstcStatus r;
    r = get_property_value ("preview", "audiosrcpreview", "listen-to", an);
    if (r != GSTC_OK) {
      return NULL;
    }
    r = get_property_value ("preview", "videosrcpreview", "listen-to", vn);
    if (r != GSTC_OK) {
      return NULL;
    }
    pd->cmd = CREATE | PLAY;
    sprintf (pd->pipename, "%s", "publish");
    ret = json_object_get_string_member (obj, "url");
    if (!ret)
      return NULL;
    memcpy (pd->__args.push_uri, ret, strlen (ret) + 1);
    sprintf (pd->__str, __STREAM_OUT__rtmp (atrack, vtrack),
        pd->__args.push_uri, pd->pipename, vn, pd->pipename, an);
    g_print ("publish %s\n", pd->__str);

  } else if (!strcmp (cmd, "publish_stop")) {

    g_print ("stop \n");
    pd->cmd = DELETE;
    sprintf (pd->pipename, "%s", "publish");

  } else if (!strcmp (cmd, "play")) {

    g_print ("play  \n");
    pd->cmd = PLAY;

  } else if (!strcmp (cmd, "delete")) {

    g_print ("delete \n");
    pd->cmd = DELETE;
    convert_process (pd);
    sprintf (pd->pipename, "channel-id-%d", id);

    
  } else {

  }

  convert_process (pd);
  g_object_unref(parser);
  free (pd);
  return NULL;
}
