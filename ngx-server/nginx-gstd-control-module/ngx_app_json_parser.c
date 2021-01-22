#include <gstd_pipe_logic_build.h>
#include <json-glib/json-glib.h>
#include "libgstc.h"
#include "partten.h"

GstClient* connect_gstd(){
  GstClient *client;
  GstcStatus ret;
  const char *address = "127.0.0.1";
  const unsigned int port = 5000;
  const long wait_time = -1;
  const int keep_open = 1;

  ret = gstc_client_new (address, port, wait_time, keep_open, &client);
  if (GSTC_OK != ret) {
  }
  return client; 
}

gint is_exist(gchar* pipename){
  GstClient *client = connect_gstd();
  gchar** pipelist;
  gint len;
  gstc_pipeline_list(client, &pipelist, &len);
  for(int i=0; i<len; i++){
    if( !strcmp( pipename, pipelist[i] ) ){
      ngx_log_error(NGX_LOG_ERR,ngx_cycle->log,0,"Pipeline exist!\n");
      return 1;
    }
  }
  gstc_client_free (client);
  return 0;
}

GstcStatus get_property_value(const gchar* pname,const gchar *element, const gchar *property, gchar *value){
  GstClient *client = connect_gstd();
  GstcStatus ret;

  ret = gstc_element_get (client, pname, element, property, "%s", value);
  if (GSTC_OK == ret) {
    ngx_log_error(NGX_LOG_ERR,ngx_cycle->log,0,"Get value %s = %s!\n", property, value);
  } else {
    ngx_log_error(NGX_LOG_ERR,ngx_cycle->log,0,"Error get value\n");
  }
  gstc_client_free (client);
  return ret;
}

void create_gstd(GstClient *client, PipelineDescribe* pd){
  GstcStatus ret;
  if(is_exist(pd->pipename)){
    return ;
  }
  ret = gstc_pipeline_create(client, pd->pipename, pd->__str);
  if (GSTC_OK == ret) {
    ngx_log_error(NGX_LOG_ERR,ngx_cycle->log,0,"Pipeline created successfully!\n");
  } else {
    ngx_log_error(NGX_LOG_ERR,ngx_cycle->log,0,"Error creating pipeline:%s-->%s\n",pd->pipename,pd->__str);
  }
}

void play_gstd(GstClient *client, PipelineDescribe* pd){
  GstcStatus ret;
  ret = gstc_pipeline_play (client, pd->pipename);
  if (GSTC_OK == ret) {
    ngx_log_error(NGX_LOG_ERR, ngx_cycle->log, 0,"Pipeline set to playing!\n");
  } else {
    ngx_log_error(NGX_LOG_ERR, ngx_cycle->log, 0,"Unable to play pipeline: \n");
  }
}

void stop_gstd(GstClient *client, PipelineDescribe* pd){
  GstcStatus ret;
  ret = gstc_pipeline_pause(client, pd->pipename);
  if (GSTC_OK == ret) {
    ngx_log_error(NGX_LOG_ERR, ngx_cycle->log, 0,"Pipeline set to stop !\n");
  } else {
    ngx_log_error(NGX_LOG_ERR, ngx_cycle->log, 0,"Unable to stop pipeline: \n");
  }
}

void delete_gstd(GstClient *client, PipelineDescribe* pd){
  GstcStatus ret;
  ret = gstc_pipeline_delete(client, pd->pipename);
  if (GSTC_OK == ret) {
    ngx_log_error(NGX_LOG_ERR, ngx_cycle->log, 0,"Pipeline set to delete !\n");
  } else {
    ngx_log_error(NGX_LOG_ERR, ngx_cycle->log, 0,"Unable to delete pipeline: \n");
  }
}

//element_set pipe_4_sink interpipesrc1 listen-to src_2
void set_gstd(GstClient *client, PipelineDescribe* pd){
  GstcStatus ret;
  //GstElement** ele =NULL;
  char** ele =NULL;
  gint len;

  ret = gstc_pipeline_list_elements(client, pd->pipename, &ele, &len);
  for(int i = 0; i < len; i++){
    ngx_log_error(NGX_LOG_ERR, ngx_cycle->log, 0,"element name %s\n",ele[i]);
  }
  for(int i = 0; i < 1024; i++){
   if(pd->__args.sets[i].s == 1){
    ret = gstc_element_set (client, pd->pipename, pd->__args.sets[i].ele_name, pd->__args.sets[i].property, "%s", pd->__args.sets[i].property_value);
    if (GSTC_OK == ret) {
      ngx_log_error(NGX_LOG_ERR, ngx_cycle->log, 0,"Pipeline set opt %s %s %s %s\n",pd->pipename,pd->__args.sets[i].ele_name, pd->__args.sets[i].property, pd->__args.sets[i].property_value);
    } else {
      ngx_log_error(NGX_LOG_ERR, ngx_cycle->log, 0,"Unable to set pipeline: \n");
    }
   }else break;
  }
}

void convert_process(PipelineDescribe* pd){
  GstClient *client = connect_gstd();
  if( pd->cmd & CREATE ){
    ngx_log_error(NGX_LOG_ERR, ngx_cycle->log, 0,"CREATE \n");
    create_gstd(client, pd);
  }
  if( pd->cmd & PLAY ){
    ngx_log_error(NGX_LOG_ERR, ngx_cycle->log, 0,"PLAY\n");
    play_gstd(client, pd);
  }

  if( pd->cmd & STOP){
    ngx_log_error(NGX_LOG_ERR, ngx_cycle->log, 0,"STOP\n");
    stop_gstd(client, pd);
  }

  if( pd->cmd & DELETE){
    ngx_log_error(NGX_LOG_ERR, ngx_cycle->log, 0,"DELETE\n");
    delete_gstd(client, pd);
  }

  if( pd->cmd & SET_OPT ){
    ngx_log_error(NGX_LOG_ERR, ngx_cycle->log, 0,"SET_OPT\n");
    set_gstd(client,pd);
  }
free_client:
  gstc_client_free (client);
}

gchar* message_process(gchar* msg){
  GError *error = NULL;
  const JsonObject *obj = NULL;
  JsonNode *root = NULL;
  const gchar* ret = NULL, *cmd=NULL;
  PipelineDescribe* pd = NULL;
  gchar vn[1024],an[1024];
  int id ;

  pd = g_malloc0 ( sizeof(PipelineDescribe) );
  memset(pd,0,sizeof(*pd));

  JsonParser *parser = json_parser_new();
  json_parser_load_from_data (parser,msg,strlen(msg),&error);
  if(error) {
    g_error("Unable to parse %s", msg);
    g_error_free(error);
    g_object_unref(parser);
    return NULL;
  }

  root = json_parser_get_root(parser);
  if(!root) g_error("get root node failed\n");
  obj = json_node_get_object(root);
  cmd = json_object_get_string_member(obj,"cmd");

  id = json_object_get_int_member (obj,"id");
  sprintf(pd->pipename, "%d", id);

  if(!strcmp(cmd, "pull")){
    pd->cmd = CREATE | PLAY;
    ret = json_object_get_string_member (obj,"url");
    memcpy(pd->__args.src_uri,ret,strlen(ret)+1);
    sprintf(vn,"vtrack-id-%d",id);
    sprintf(an,"atrack-id-%d",id);
    sprintf(pd->__str,__STREAM_IN__(atrack,vtrack), pd->__args.src_uri, vn, an);

    ngx_log_error(NGX_LOG_ERR, ngx_cycle->log, 0,"pull-- %s \n",pd->__str);

    convert_process(pd);
    sprintf(pd->pipename, "channel-id-%d", id);
    sprintf(pd->__args.out_uri, "rtmp://192.168.0.134/live/chan-id-%d",id);
    sprintf(pd->__str, __STREAM_OUT__rtmp(atrack,vtrack), pd->__args.out_uri, pd->pipename, vn, pd->pipename, an);

  }else if(!strcmp(cmd, "switch")){
    int a,v;
    ngx_log_error(NGX_LOG_ERR, ngx_cycle->log, 0,"switch \n");
    pd->cmd = CREATE | PLAY;
    sprintf(pd->pipename, "%s","preview");
    sprintf(pd->__args.prev_uri, "%s", "rtmp://192.168.0.134/live/preview");
    sprintf(vn,"vtrack-id-%d",id);
    sprintf(an,"atrack-id-%d",id);
    sprintf(pd->__str, __STREAM_OUT__rtmp(atrack,vtrack), pd->__args.prev_uri, pd->pipename, vn, pd->pipename, an);
    convert_process(pd);

    pd->cmd = SET_OPT;
    ret = json_object_get_string_member (obj,"video_id");
    v = atoi(ret);
    if(v !=-1){
      sprintf(pd->__args.sets[0].ele_name, "%spreview", "videosrc");
      sprintf(pd->__args.sets[0].property, "%s", "listen-to");
      sprintf(pd->__args.sets[0].property_value, "vtrack-id-%s",ret);
      pd->__args.sets[0].s = 1;
    }
    ret = json_object_get_string_member (obj,"audio_id");
    a = atoi(ret);
    if(a !=-1){
      sprintf(pd->__args.sets[1].ele_name, "%spreview", "audiosrc");
      sprintf(pd->__args.sets[1].property, "%s", "listen-to");
      sprintf(pd->__args.sets[1].property_value , "atrack-id-%s",ret);
      pd->__args.sets[1].s = 1;
    }

    if(is_exist("publish")){
      convert_process(pd);
      if( a != -1){
        sprintf(pd->__args.sets[1].ele_name, "%spublish", "audiosrc");
      }
      if( v != -1){
        sprintf(pd->__args.sets[0].ele_name, "%spublish", "videosrc");
      }
      sprintf(pd->pipename, "%s", "publish");
    } 

  }else if(!strcmp(cmd, "publish")){
    GstcStatus r;
    r = get_property_value("preview","audiosrcpreview","listen-to",an);
    if(ret != GSTC_OK){
      return NULL;
    }
    r = get_property_value("preview","videosrcpreview","listen-to",vn);
    if(ret != GSTC_OK){
      return NULL;
    }
    pd->cmd = CREATE | PLAY;
    sprintf(pd->pipename, "%s", "publish");
    ret = json_object_get_string_member (obj,"url");
    memcpy(pd->__args.push_uri, ret, strlen(ret)+1);
    sprintf(pd->__str, __STREAM_OUT__rtmp(atrack,vtrack), pd->__args.push_uri, pd->pipename, vn, pd->pipename, an);
    ngx_log_error(NGX_LOG_ERR, ngx_cycle->log, 0,"publish %s\n",pd->__str);

  }else if(!strcmp(cmd, "stop")){

    ngx_log_error(NGX_LOG_ERR, ngx_cycle->log, 0,"stop \n");
    pd->cmd = STOP;

  }else if(!strcmp(cmd, "play")){

    ngx_log_error(NGX_LOG_ERR, ngx_cycle->log, 0,"play  \n");
    pd->cmd = PLAY;

  }else if(!strcmp(cmd, "delete")){

    ngx_log_error(NGX_LOG_ERR, ngx_cycle->log, 0,"delete \n");
    pd->cmd = DELETE;
    convert_process(pd);
    sprintf(pd->pipename, "channel-id-%d", id);

  }else{
  
  }

  convert_process(pd);
  free(pd);
  return NULL;
}

