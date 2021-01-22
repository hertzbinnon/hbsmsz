//
// https://www.cnblogs.com/tanghe1219/p/10286559.html
// https://blog.csdn.net/qq_27443505/article/details/83351694
// https://www.jianshu.com/p/6939f71cf741
//
#include <ngx_config.h>
#include <ngx_core.h>
#include <ngx_http.h>
#include "libgstc.h"
 
static ngx_http_request_body_filter_pt  ngx_http_next_request_body_filter;
static ngx_int_t ngx_gstd_control_request_body_filter(ngx_http_request_t *r, ngx_chain_t *in){
  char json_req[1024*10];
  ngx_chain_t* tmp = r->request_body->bufs;
  int writed = 0;

  ngx_log_error(NGX_LOG_ERR, ngx_cycle->log,0,"Request_body\n");
  memset(json_req, 0, sizeof(json_req));

  for(;tmp;tmp = tmp->next){
    //u_int content_len = tmp->buf->end - tmp->buf->start;
    u_int content_len = tmp->buf->last - tmp->buf->pos ;
    ngx_memcpy(json_req + writed,tmp->buf->start,content_len);
    writed += content_len;
  }
  if(!writed) return 0;
  ngx_log_error(NGX_LOG_ERR, ngx_cycle->log,0,"request_body: %s\n",json_req);
  return 0;
#if 0
    if (last_buf_in_this_filter) {
        r->headers_in.content_length_n = cry->total_len;
        r->headers_in.content_length->value.data = ngx_palloc(r->pool, NGX_OFF_T_LEN);
        if (r->headers_in.content_length->value.data == NULL) {
            return NGX_HTTP_INTERNAL_SERVER_ERROR;
        }
        r->headers_in.content_length->value.len =
            ngx_sprintf(r->headers_in.content_length->value.data, "%O", r->headers_in.content_length_n)
            - r->headers_in.content_length->value.data;
    }

    return ngx_http_next_request_body_filter(r, in);
#endif
}

static ngx_int_t ngx_gstd_control_post_conf(ngx_conf_t *cf){
  ngx_log_debug(NGX_LOG_ERR, ngx_cycle->log,0,"request_body\n");
  ngx_http_next_request_body_filter = ngx_http_top_request_body_filter;
  ngx_http_top_request_body_filter = ngx_gstd_control_request_body_filter;
}

static ngx_int_t ngx_gstd_control_handler(ngx_http_request_t *r);
 
static char* ngx_gstd_control(ngx_conf_t *cf, ngx_command_t *cmd, void *conf);
// 定义HTTP模块
static ngx_command_t ngx_gstd_control_commands[] = {
{
    ngx_string("postserver"),
    NGX_HTTP_MAIN_CONF | NGX_HTTP_SRV_CONF | NGX_HTTP_LOC_CONF | NGX_HTTP_LMT_CONF | \
    NGX_CONF_NOARGS,
    ngx_gstd_control,
    NGX_HTTP_LOC_CONF_OFFSET,
    0,
    NULL
    },
    ngx_null_command
};
 
static ngx_http_module_t ngx_gstd_control_module_ctx = {
    NULL,
    NULL,//ngx_gstd_control_post_conf, //NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL
};
 
ngx_module_t ngx_gstd_control_module = {
    NGX_MODULE_V1,
    &ngx_gstd_control_module_ctx,
    ngx_gstd_control_commands,
    NGX_HTTP_MODULE,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
    NGX_MODULE_V1_PADDING
};
 //定义模块触发函数
static char *ngx_gstd_control(ngx_conf_t *cf, ngx_command_t *cmd, void *conf) {
  ngx_http_core_loc_conf_t *clcf;
 
  clcf = ngx_http_conf_get_module_loc_conf(cf, ngx_http_core_module);
 
  clcf->handler = ngx_gstd_control_handler;
 

  return NGX_CONF_OK;
}
//编写请求处理方法handler 
//
//
//  URL /postserver
//
static char* rep_buffer;
static void fake_callback(ngx_http_request_t *r){
  char json_req[1024*10];
  ngx_chain_t* tmp = r->request_body->bufs;
  int writed = 0;

  memset(json_req, 0, sizeof(json_req));

  for(;tmp;tmp = tmp->next){
    //u_int content_len = tmp->buf->end - tmp->buf->start;
    u_int content_len = tmp->buf->last - tmp->buf->pos ;
    ngx_memcpy(json_req + writed,tmp->buf->start,content_len);
    writed += content_len;
  }
  if(!writed) return;
  ngx_log_error(NGX_LOG_ERR, ngx_cycle->log,0,"requeset_body: %s\n",json_req);
  rep_buffer = message_process(json_req);
};

static ngx_int_t ngx_gstd_control_handler(ngx_http_request_t *r) {
   ngx_int_t rc=0 ;
   //ngx_int_t stop_flags = 0;
	
   //ngx_log_error(NGX_LOG_ERR, ngx_cycle->log, 0, "hertz requeset_line  : %s\n  \n",r->request_line.data);
   //ngx_log_error(NGX_LOG_ERR, ngx_cycle->log, 0, "hertz requeset_header  : %s\n  \n",r->header_in->start);
again:	
   rc =ngx_http_read_client_request_body(r, fake_callback);
   if( rc < 0 ){
     ngx_log_error(NGX_LOG_ERR, ngx_cycle->log, 0, "Read body error %d dd", rc );
     goto again;
   }
   ngx_str_t type = ngx_string("text/plain");
   ngx_str_t response = ngx_string("ok");

   r->headers_out.status = NGX_HTTP_OK;
   r->headers_out.content_length_n = response.len;
   r->headers_out.content_type = type;

   rc = ngx_http_send_header(r);
   if (rc == NGX_ERROR || rc > NGX_OK || r->header_only) {
       return rc;
   }

   ngx_buf_t *b;
   b = ngx_create_temp_buf(r->pool, response.len);
   if (b == NULL) {
       return NGX_HTTP_INTERNAL_SERVER_ERROR;
   }

   ngx_memcpy(b->pos, response.data, response.len);
   b->last = b->pos + response.len;
   b->last_buf = 1;

   ngx_chain_t out;
   out.buf = b;
   out.next = NULL;
	
   return ngx_http_output_filter(r, &out);
}

