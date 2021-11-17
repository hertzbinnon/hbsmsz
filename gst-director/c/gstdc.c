#include <gstd_pipe_logic_build.h>
#include <json-glib/json-glib.h>
#include "libgstc.h"
#include "partten.h"
#include <glib.h>
#include <glib/gprintf.h>
#define MEDIA_PATH "/tmp"
GstClient *__client = NULL;
extern char* host;
extern int mode;

char* make_response_mesg(const char* , int , int , int, gchar*, int ); 

GstClient * connect_gstd ()
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
        g_print ("Connected daemon Error !!! \n");
      }
  }
  if (__client) {
    ret = gstc_client_ping(__client);
    if (GSTC_OK != ret) {
      g_print ("Connected Daemon Error !!! \n");
      gstc_client_free(__client);

try_again:
      __client=NULL;
      ret = gstc_client_new (address, port, wait_time, keep_open, &__client);
      if (GSTC_OK != ret) {
        g_print ("Connected daemon Error !!! \n");
	sleep(1);
	goto try_again;
      }
    }
  }
  return __client;
}

gint is_source_null()
{
  GstcStatus ret;
  GstClient *client = connect_gstd ();
  gchar **pipelist;
  gint len;
  gint flag =1;

  ret = gstc_pipeline_list (client, &pipelist, &len);
  if (ret != GSTC_OK)
    return flag;

  for (int i = 0; i < len; i++) {
      int f = atoi(pipelist[i]);
      g_print("name = %s(%d)\n",pipelist[i],f);
      if( f > 0 ){
         flag = 0;
	 //break;
      }
  }
  for (int i = 0; i < len; i++) {
      free(pipelist[i]);
  }
  free(pipelist);
//  gstc_client_free (client);
  return flag;
}

gint get_source_nums(){
  GstcStatus ret;
  GstClient *client = connect_gstd ();
  gchar **pipelist;
  gint len;
  ret = gstc_pipeline_list (client, &pipelist, &len);
  gint flag = 0;
  if (ret != GSTC_OK){
    return flag ;
  }
  for (int i = 0; i < len; i++) {
    if (!strncmp ("channel-id-", pipelist[i],11)) {
      flag += 1;
      g_print("++++> %s\n",pipelist[i]);
    }
  }
  return flag;
}
gint is_exist (gchar * pipename)
{
  GstcStatus ret;
  GstClient *client = connect_gstd ();
  gchar **pipelist;
  gint len;
  gint flag = 0;
  ret = gstc_pipeline_list (client, &pipelist, &len);
  if (ret != GSTC_OK){
    return flag ;
  }

  for (int i = 0; i < len; i++) {
    if (!strcmp (pipename, pipelist[i])) {
      flag = 1;
    }
    g_print("--> %s\n",pipelist[i]);
  }

  for (int i = 0; i < len; i++) {
      free(pipelist[i]);
  }
  free(pipelist);
//  gstc_client_free (client);
  return flag;
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
    {g_print("list error\n");return;}
  for (int i = 0; i < len; i++) {
    g_print ("element name %s\n", ele[i]);
    free(ele[i]);
  }
  free(ele);
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
    } 
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

gint clear_all()
{
  GstcStatus ret;
  GstClient *client = connect_gstd ();
  gchar **pipelist;
  gint len;
  PipelineDescribe * pd;
  pd = g_malloc0 (sizeof (PipelineDescribe));
  memset (pd, 0, sizeof (*pd));

  ret = gstc_pipeline_list (client, &pipelist, &len);
  if (ret != GSTC_OK)
    return 1;

  for (int i = 0; i < len; i++) {
    pd->cmd = DELETE;
    sprintf (pd->pipename, "%s", pipelist[i]);
    convert_process (pd);
  }
  for (int i = 0; i < len; i++) {
      free(pipelist[i]);
  }
  free(pipelist);
  free(pd);
//  gstc_client_free (client);
  return 0;
}
#if 1 //rtmp/rtsp/http to udp 
gint prepare_source(PipelineDescribe* pd, gint id, const gchar* pro){
  gchar out_url[1024];
  gint new_id = 12340+id;
  sprintf (out_url,"tcp://%s:%d","127.0.0.1",new_id);
  pd->cmd = CREATE | PLAY;
  sprintf (pd->pipename, "dummy%d", new_id);
  if(!strncmp(pro,"rtmp",4)){
    //sprintf (pd->__str, __STREAM_TRANSMUXER_rtmp2udp(), pd->__args.src_uri, "127.0.0.1", new_id);
    if(mode == 4)
    sprintf (pd->__str, __STREAM_TRANSMUXER_rtmp2tcp(), pd->__args.src_uri, 
		    (long long)0, "127.0.0.1", new_id);
    else
    sprintf (pd->__str, __STREAM_TRANSMUXER_rtmp2tcp_8k(), pd->__args.src_uri, 
		    (long long)0, "127.0.0.1", new_id);
  }else{
  }
  g_print ("prepare -- %s \n", pd->__str);
  convert_process (pd);
  memcpy (pd->__args.src_uri, out_url, strlen (out_url)+1);
  g_print ("url -- %s \n", out_url);
  g_print ("url -- %s \n",pd->__args.src_uri );
  sleep(2);
  return new_id;
}
#endif
gchar * message_process (const gchar * msg)
{
  GError *error = NULL;
  JsonObject *obj = NULL;
  JsonNode *root = NULL;
  const gchar *ret = NULL, *cmd = NULL;
  PipelineDescribe *pd = NULL;
  gchar vn[1024], an[1024], rn[1024],ourl[1024];
  int id = -2, errorno = 0,aid = -1 ,vid = -1;
  char* resp;
 
  pd = g_malloc0 (sizeof (PipelineDescribe));
  memset (pd, 0, sizeof (*pd));

  JsonParser *parser = json_parser_new ();
  json_parser_load_from_data (parser, msg, strlen (msg), &error);
  if (error) {
    g_print ("Unable to parse %s", msg);
    g_error_free (error);
    g_object_unref (parser);
    goto error;
  }

  root = json_parser_get_root (parser);
  if (!root){
    g_print ("Get root node failed\n");
    goto error;
  }
  obj = json_node_get_object (root);
  cmd = json_object_get_string_member (obj, "cmd");
  if (!cmd)
    goto error;
  g_print("sent %s cmd \n", cmd);

  id = json_object_get_int_member (obj, "id");
  if(id <= 0){
    g_print("Source id must be > 0\n");
#if 0 // important !!!!
    goto error;
#endif
  }

  if (!strcmp (cmd, "pull")) {
    if(get_source_nums() == 9) { errorno=1; goto error;}
    ret = json_object_get_string_member (obj, "url");
    if (!ret){
      goto error;
    }
    memcpy (pd->__args.src_uri, ret, strlen (ret) + 1);
    g_print ("url -- %s \n", pd->__args.src_uri);
#if 1 //rtmp/rtsp/http to udp 
    gint port=-1;
    if(strncmp(ret,"tcp",3)){
      port = prepare_source(pd,id,ret);
    }else {
      port = 12340 + (id % 5 ? id % 5 : (id == 10 ? id - 5: id));
    }     
#endif
    g_print ("url -- %s \n", pd->__args.src_uri);
    pd->cmd = CREATE | PLAY;
    sprintf (pd->pipename, "%d", id);
    sprintf (vn, "vtrack-id-%d", id);
    sprintf (an, "atrack-id-%d", id);
    //sprintf (pd->__str, __STREAM_IN__ (atrack, vtrack), pd->__args.src_uri, vn,an);
    //sprintf (pd->__str, __STREAM_IN__TCP_TEST (atrack, vtrack), port, id, vn,an);
    if( mode == 4)
    sprintf (pd->__str, __STREAM_IN__TCP (atrack, vtrack), port, vn,an);
    else
    sprintf (pd->__str, __STREAM_IN__TCP_8k (atrack, vtrack), port, vn,an);

    g_print ("pull-- %s \n", pd->__str);
    convert_process (pd);

    sprintf (pd->pipename, "channel-id-%d", id);
    sprintf (pd->__args.out_uri, "rtmp://127.0.0.1/live/chan-id-%d", id);
    
       JsonObject *sub_obj = json_object_get_object_member (obj,"encoder_params");
       int bitrate = json_object_get_int_member (sub_obj,"bitrate") ;
    if( mode == 4) 
    sprintf (pd->__str, __STREAM_OUT__rtmp (atrack, vtrack), pd->__args.out_uri,
        pd->pipename, vn, bitrate / 1000,pd->pipename, an);
    else
    sprintf (pd->__str, __STREAM_OUT__rtmp_8k (atrack, vtrack), pd->__args.out_uri,
        pd->pipename, vn, bitrate / 1000,pd->pipename, an);
    g_print ("pull-- %s \n", pd->__str);
    convert_process (pd);
#if 1 // logo render
  } else if (!strcmp (cmd, "logo")) {
    GstcStatus r;
    gint iret = -1;
    gint rid = json_object_get_int_member (obj,"render_id");
    if(rid == -1) {
      g_print("Only one Render \n");
      rid = 0;
    }
    r = get_property_value ("preview", "videosrcpreview", "listen-to", vn);
    if (r != GSTC_OK) {
      goto error;
    }
    sprintf (pd->pipename, "videorender-%d", rid);
    ret = json_object_get_string_member (obj,"action");
    if(!strcmp(ret, "add")){
      if (is_exist (pd->pipename)) {
	g_print("pipeline: %s is exist\n", pd->pipename);
        goto error;
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
     if (is_exist ("preview")) {
      memset(pd->__args.sets,0,sizeof(pd->__args.sets));
      sprintf (pd->pipename, "%s","preview");
      sprintf (pd->__args.sets[0].ele_name, "%spreview", "videosrc");
      sprintf (pd->__args.sets[0].property, "%s", "listen-to");
      sprintf (pd->__args.sets[0].property_value, "videorender%d", rid);
      pd->__args.sets[0].s = 1;
      convert_process (pd);
     }

     if (is_exist ("publish")) {
      memset(pd->__args.sets,0,sizeof(pd->__args.sets));
      //g_print("%d %d %d\n",sizeof(*pd->__args.sets),sizeof(pd->__args.sets),sizeof(OptionSet));
      sprintf (pd->pipename, "%s", "publish");
      sprintf (pd->__args.sets[0].ele_name, "%spublish", "videosrc");
      sprintf (pd->__args.sets[0].property, "%s", "listen-to");
      sprintf (pd->__args.sets[0].property_value, "videorender%d", rid);
      pd->__args.sets[0].s = 1;
      convert_process (pd);
     }

    }else if(!strcmp(ret, "update")){
      if (!is_exist (pd->pipename)) {
	g_print("pipeline: %s is not exist\n", pd->pipename);
        goto error;
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
      convert_process (pd);

    }else if(!strcmp(ret, "delete")){
      gchar name[1024];

      sprintf (name, "videorendersrc%d", rid);
      r = get_property_value (pd->pipename,  name, "listen-to", rn);
      if (r != GSTC_OK) {
        goto error;
      }

      pd->cmd = SET_OPT;
     if (is_exist ("preview")) {
      sprintf (pd->pipename, "%s","preview");
      sprintf (pd->__args.sets[0].ele_name, "%spreview", "videosrc");
      sprintf (pd->__args.sets[0].property, "%s", "listen-to");
      sprintf (pd->__args.sets[0].property_value, "%s", rn);
      pd->__args.sets[0].s = 1;
      convert_process (pd);
     }

     if (is_exist ("publish")) {
      sprintf (pd->pipename, "%s", "publish");
      sprintf (pd->__args.sets[0].ele_name, "%spublish", "videosrc");
      sprintf (pd->__args.sets[0].property, "%s", "listen-to");
      sprintf (pd->__args.sets[0].property_value, "%s", rn);
      pd->__args.sets[0].s = 1;
      convert_process (pd);
     }

      pd->cmd = DELETE;
      sprintf (pd->pipename, "videorender-%d", rid);
      convert_process (pd);
    }else{
	g_print("No implement action %s\n", ret);

    }
#endif
  } else if (!strcmp (cmd, "switch")) {
    int a, v, rs=0;
    char cur_v[100],cur_a[100];
    GstcStatus r;
    sleep(1);
    g_print ("switch \n");
    sprintf (pd->pipename, "%s", "preview");
    if (is_exist(pd->pipename)) {
	g_print("pipeline: %s is exist\n", pd->pipename);
	goto set_opt;
    }
    pd->cmd = CREATE | PLAY;
    
    sprintf (pd->__args.prev_uri, "%s", "rtmp://127.0.0.1/live/preview");
    sprintf (vn, "vtrack-id-%d", id);
    sprintf (an, "atrack-id-%d", id);
       JsonObject *sub_obj = json_object_get_object_member (obj,"encoder_params");
       int bitrate = json_object_get_int_member (sub_obj,"bitrate");
    if(mode == 4)
      sprintf (pd->__str, __STREAM_OUT__rtmp (atrack, vtrack),
        pd->__args.prev_uri, pd->pipename, vn, bitrate / 1000, pd->pipename, an);
    else
      sprintf (pd->__str, __STREAM_OUT__rtmp_8k (atrack, vtrack),
        pd->__args.prev_uri, pd->pipename, vn, bitrate / 1000, pd->pipename, an);
    convert_process (pd);
    g_print("switch %s\n", pd->__str);
    goto error;
set_opt:
    r = get_property_value ("preview", "audiosrcpreview", "listen-to", an);
    if (r != GSTC_OK) {
        goto error;
    }
    r = get_property_value ("preview", "videosrcpreview", "listen-to", vn);
    if (r != GSTC_OK) {
        goto error;
    }

    pd->cmd = SET_OPT;
    ret = json_object_get_string_member (obj, "video_id");
    if (!ret){
      g_print("video_id is error !!! \n");
        goto error;
    }
    v = atoi (ret);
    if (v != -1) {
      sprintf (cur_v, "vtrack-id-%d", v);
      vid = v;
      if(strcmp(cur_v,vn)){
      sprintf (pd->__args.sets[0].ele_name, "%spreview", "videosrc");
      sprintf (pd->__args.sets[0].property, "%s", "listen-to");

      for(int i=0; i<10; i++){
        gchar p[1024];
	sprintf(p,"videorender-%d",i);
        if (is_exist(p)) {
		rs++;
	}
      }
      if (rs > 0) {
	gint rid = rs > 1 ? 0 : rs-1;
        PipelineDescribe *pdt = NULL;
        pdt = g_malloc0 (sizeof (PipelineDescribe));
        memset (pdt, 0, sizeof (*pd));
        pdt->cmd = SET_OPT;
        sprintf (pdt->pipename, "videorender-%d", rid);
        sprintf (pdt->__args.sets[0].ele_name, "videorendersrc%d", rid);
        r = get_property_value ( pdt->pipename,pdt->__args.sets[0].ele_name, "listen-to", vn);
        g_print("%s ==  %s\n",vn, cur_v);
        if (r == GSTC_OK && strcmp(cur_v,vn) ) {
          sprintf (pdt->__args.sets[0].property, "%s", "listen-to");
          sprintf (pdt->__args.sets[0].property_value, "vtrack-id-%d", v);
          pdt->__args.sets[0].s = 1;
          convert_process (pdt);
	}
        free (pdt);

        sprintf (pd->__args.sets[0].property_value, "videorender%d", rs-1);
      }else{
        sprintf (pd->__args.sets[0].property_value, "vtrack-id-%d", v);
      }
      pd->__args.sets[0].s = 1;
      }
    }
    ret = json_object_get_string_member (obj, "audio_id");
    if (!ret){
      g_print("audio_id is error !!! \n");
        goto error;
    }
    a = atoi (ret);
    if (a != -1) {
      sprintf (cur_a, "atrack-id-%d", a);
      aid = a;
      if(strcmp(cur_a,an)){
      sprintf (pd->__args.sets[1].ele_name, "%spreview", "audiosrc");
      sprintf (pd->__args.sets[1].property, "%s", "listen-to");
      sprintf (pd->__args.sets[1].property_value, "atrack-id-%d", a);
      pd->__args.sets[1].s = 1;
     }
    }

    if (is_exist ("publish")) {
	    if(rs > 0){
      pd->__args.sets[0].s = 0;
	    }
      convert_process (pd);
      if (a != -1) {
      if(strcmp(cur_a,an)){
        sprintf (pd->__args.sets[1].ele_name, "%spublish", "audiosrc");
      }
      }
      if (v != -1) {
      if(strcmp(cur_v,vn)){
        sprintf (pd->__args.sets[0].ele_name, "%spublish", "videosrc");
      }
      }
      sprintf (pd->pipename, "%s", "publish");
    }
	    if(rs > 0){
      pd->__args.sets[0].s = 0;
	    }
    convert_process (pd);

  } else if (!strcmp (cmd, "publish")) {
    GstcStatus r;
    if (is_exist ("publish")) {
        errorno=1; goto error;
    }
    r = get_property_value ("preview", "audiosrcpreview", "listen-to", an);
    if (r != GSTC_OK) {
        goto error;
    }
    r = get_property_value ("preview", "videosrcpreview", "listen-to", vn);
    if (r != GSTC_OK) {
        goto error;
    }
    pd->cmd = CREATE | PLAY;
    sprintf (pd->pipename, "%s", "publish");
    ret = json_object_get_string_member (obj, "url");
    if (!ret)
        goto error;
       JsonObject *sub_obj = json_object_get_object_member (obj,"encoder_params");
       int bitrate = json_object_get_int_member (sub_obj,"bitrate");
    memcpy (pd->__args.push_uri, ret, strlen (ret) + 1);
    if( mode == 4)
    sprintf (pd->__str, __STREAM_OUT__rtmp_pub(atrack, vtrack),
        pd->__args.push_uri, pd->pipename, vn, bitrate/1000, pd->pipename, an);
    else
    sprintf (pd->__str, __STREAM_OUT__rtmp_pub_8k(atrack, vtrack),
        pd->__args.push_uri, pd->pipename, vn, bitrate/1000, pd->pipename, an);
    g_print ("publish %s\n", pd->__str);
    convert_process (pd);
    sprintf(ourl,"%s",pd->__args.push_uri);

  } else if (!strcmp (cmd, "delay")) {
    gint msecs = json_object_get_int_member (obj,"time");
#if 0
    gchar vn[1024], an[1024];

    pd->cmd = DELETE;
    sprintf (pd->pipename, "dummy%d", 12340+id);
    convert_process (pd);

    sprintf (pd->pipename, "%d", id);
    convert_process (pd);

    pd->cmd = CREATE | PLAY;
    sprintf (pd->pipename, "dummy%d", 12340+id);
    sprintf (pd->__str, __STREAM_TRANSMUXER_rtmp2tcp(), "rtmp://127.0.0.1/live/ch0" 
		    ,(long long)msecs*1000000, "127.0.0.1", 12340+id);
    g_print("set %s to %s \n",pd->pipename,pd->__str);
    convert_process (pd);

    sprintf (pd->pipename, "%d", id);
    sprintf (vn, "vtrack-id-%d", id);
    sprintf (an, "atrack-id-%d", id);
    sprintf (pd->__str, __STREAM_IN__TCP (atrack, vtrack), 12340+id, id, vn,an);
    g_print("set %s to %s \n",pd->pipename,pd->__str);
    convert_process (pd);
#else
    pd->cmd = SET_OPT;
    sprintf (pd->pipename, "dummy%d", 12340+id);
    sprintf (pd->__args.sets[0].ele_name, "%s", "delayer");
    sprintf (pd->__args.sets[0].property, "%s", "min-threshold-time");
    sprintf (pd->__args.sets[0].property_value, "%lld", (long long)msecs*1000000);
    pd->__args.sets[0].s = 1;
    convert_process (pd);
#endif

	 // is_exist("test-->");
  } else if (!strcmp (cmd, "volume")) {
     //errorno=1; goto error;
    ret = json_object_get_string_member (obj,"audio_id");
    //gint audio_id = atoi(ret);
    int r = json_object_get_int_member (obj,"val");
    double val =  r/100.0;
    g_print("set audio vol to %d %f \n",r,val);
    //if( val > 1.0)
    //  val = 1.0;

    pd->cmd = SET_OPT;
    sprintf (pd->pipename, "%d", id);
    sprintf (pd->__args.sets[0].ele_name, "%s", "volume");
    sprintf (pd->__args.sets[0].property, "%s", "volume");
    sprintf (pd->__args.sets[0].property_value, "%f", val);
    pd->__args.sets[0].s = 1;
    convert_process (pd);

  } else if (!strcmp (cmd, "publish_stop")) {

    g_print ("stop \n");
    pd->cmd = DELETE;
    sprintf (pd->pipename, "%s", "publish");
    convert_process (pd);

  } else if (!strcmp (cmd, "play")) {

    g_print ("play  \n");
    pd->cmd = PLAY;

  } else if (!strcmp (cmd, "stop_all")) {
        clear_all();               
  } else if (!strcmp (cmd, "refresh")) {
        // nothing to do
  } else if (!strcmp (cmd, "delete")) {
    g_print ("delete \n");
    pd->cmd = DELETE;
    sprintf (pd->pipename, "%d", id);
    convert_process (pd);
    sprintf (pd->pipename, "channel-id-%d", id);
    convert_process (pd);
    sprintf (pd->pipename, "dummy%d", 12340+id);
    convert_process (pd);

    if(is_source_null()){
	g_print("Clear!!!\n");
        clear_all();               
    }
  } else {

  }
error:
  resp = make_response_mesg(cmd, id, vid, aid, ourl, errorno);
  g_object_unref(parser);
  free (pd);
  return resp;
}

char* make_response_mesg(const gchar* cmd, int id, int video, int audio, gchar* ourl, int errorno){ 
  JsonBuilder *builder = json_builder_new();
  json_builder_begin_object(builder);
  gchar url[1024];
  g_print("build %s cmd \n", cmd);

  json_builder_set_member_name(builder, "cmd");
  json_builder_add_string_value(builder, cmd);

  json_builder_set_member_name(builder, "id");
  json_builder_add_int_value(builder, id);

  if(!strcmp(cmd, "pull") || !strcmp(cmd,"delete")){
    gchar stream_id[1024];
    gint x=0,y=0;

    sprintf(stream_id,"%d",id);
    sprintf(url, "rtmp://%s/live/chan-id-%d",host,id); 
    json_builder_set_member_name(builder, "stream_id");
    json_builder_add_string_value(builder, stream_id);

    json_builder_set_member_name(builder, "url");
    json_builder_add_string_value(builder,url);
    if(!strcmp(cmd, "pull")){
      json_builder_set_member_name(builder, "encoder_params");
      json_builder_begin_object(builder);
      json_builder_set_member_name(builder, "bitrate");
      json_builder_add_int_value(builder, 1000000);
       if(mode == 4 ){
	     x=3840,y=1920;
       }else if(mode == 8 ){
	     x=7680,y=3840;
       }else{
	     x=3840,y=1920;
       }
       json_builder_set_member_name(builder, "width");
       json_builder_add_int_value(builder, x);

       json_builder_set_member_name(builder, "height");
       json_builder_add_int_value(builder, y);

       json_builder_set_member_name(builder, "fps");
       json_builder_add_int_value(builder, 30);

       json_builder_end_object(builder);
    }
  }
  if(!strcmp(cmd, "switch") ){
    gchar vn[1024], an[1024];
    json_builder_set_member_name(builder, "url");
    sprintf(url, "rtmp://%s/live/preview", host); 
    json_builder_add_string_value(builder,url);
    sprintf(vn, "%d", video);
    sprintf(an, "%d", audio);
    json_builder_set_member_name(builder, "video_id");
    json_builder_add_string_value(builder, vn);
    json_builder_set_member_name(builder, "audio_id");
    json_builder_add_string_value(builder, an);
  }
  if(!strcmp(cmd, "publish") ){
    json_builder_set_member_name(builder, "url");
    sprintf(url, "rtmp://%s/live/publish", host); 
    json_builder_add_string_value(builder, url);
  }
  json_builder_set_member_name(builder, "result");
  json_builder_add_string_value(builder, errorno ? "ERROR" :"OK");

  json_builder_set_member_name(builder, "errno");
  json_builder_add_int_value(builder, errorno);

  json_builder_end_object(builder);

  JsonNode *node = json_builder_get_root(builder);
  JsonGenerator *generator = json_generator_new();
  json_generator_set_root(generator, node);
  gchar *data = json_generator_to_data(generator, NULL);

  json_node_free(node);
  g_object_unref(generator);
  g_object_unref(builder);
  return data;
}
