//
//  Http.m
//  Brayatan
//
//  Created by Aldrin Martoq on 3/18/12.
//  Copyright (c) 2012 A0. All rights reserved.
//

#import "Http.h"

#define RESPONSE \
    "HTTP/1.1 200 OK\r\n" \
    "Content-Type: text/plain\r\n" \
    "Content-Length: 13\r\n" \
    "Server: Brayatan Alfa\r\n" \
    "\r\n" \
    "hola flaites\n"

static http_parser_settings settings;

typedef struct {
    uv_tcp_t handle;
    http_parser parser;
    void *data;
} client_t;

void on_close(uv_handle_t *handle) {
    //NSLog(@"disconnected\n");
    free(handle);
}

uv_buf_t on_alloc(uv_handle_t* handle, size_t suggested_size) {
    uv_buf_t buf;
    buf.base = malloc(suggested_size);
    buf.len = suggested_size;
    return buf;
}

void on_read(uv_stream_t* handle, ssize_t nread, uv_buf_t buf) {
    client_t *client = (client_t *)handle->data;
    if (nread >= 0) {
        /* parse http ... somehow */
        size_t parsed = http_parser_execute(&client->parser, &settings, buf.base, nread);
        if (parsed < nread) {
            uv_close((uv_handle_t*)handle, on_close);
        }
    } else {
        uv_err_t err = uv_last_error(uv_default_loop());
        if (err.code == UV_EOF) {
            uv_close((uv_handle_t*)handle, on_close);
        } else {
            //NSLog(@"read: %s", uv_strerror(err));
        }
    }
    free(buf.base);
}

void on_after_write(uv_write_t* req, int status) {
    uv_close((uv_handle_t*)req->handle, on_close);
    free(req);
}

int on_headers_complete(http_parser* parser) {
    //NSLog(@"http message!");
    client_t *client = (client_t *)parser->data;
    
    uv_write_t *write_req = malloc(sizeof(uv_write_t));
    uv_buf_t write_buf;
    write_buf.base = RESPONSE;
    write_buf.len = sizeof(RESPONSE);
    
    uv_write(write_req, (uv_stream_t*)&client->handle, &write_buf, 1, on_after_write);
    
    return 0;
}

void on_connection(uv_stream_t* uv_tcp, int status) {
    //NSLog(@"connected: %@", uv_tcp->data);
    
    client_t *client = malloc(sizeof(client_t));
    uv_tcp_init(uv_default_loop(), &client->handle);
    int r = uv_accept(uv_tcp, (uv_stream_t*)&client->handle);
    if (r) {
        //NSLog(@"accept: %s\n", uv_strerror(uv_last_error(uv_default_loop())));
        return;
    }
    
    http_parser_init(&client->parser, HTTP_REQUEST);

    client->handle.data = client;
    client->parser.data = client;
    client->data = uv_tcp->data;
    
    settings.on_headers_complete = on_headers_complete;
    
    uv_read_start((uv_stream_t*)&client->handle, on_alloc, on_read);
}

@implementation Http

- (id) init {
    if (self = [super init]) {
        uv_tcp = malloc(sizeof(uv_tcp_t));
        uv_tcp_init(uv_default_loop(), uv_tcp);
        uv_tcp->data = (__bridge void *)self;
    }
    
    return self;
}

- (BOOL) listenWithIP:(NSString *)ip atPort:(int)port callback:(void (^)(id a, id b))callback {
    int r = uv_tcp_bind(uv_tcp, uv_ip4_addr([ip cStringUsingEncoding:NSASCIIStringEncoding], port));
    
    if (r) {
        //NSLog(@"bind: %s\n", uv_strerror(uv_last_error(NULL)));
        return NO;
    }
    
    r = uv_listen((uv_stream_t*)uv_tcp, 128, on_connection);
    if (r) {
        //NSLog(@"listen: %s\n", uv_strerror(uv_last_error(NULL)));
        return NO;
    }
        
    return YES;
}

+ (Http *) createServerWithIP:(NSString *)ip atPort:(int)port callback:(void (^)(id a, id b))callback {    
    Http *http = [[Http alloc] init];
    if ([http listenWithIP:ip atPort:port callback:callback]) {
        NSLog(@"This is: %lu", http);
        return http;
    }
    return nil;
}

- (void) dealloc {
    free(uv_tcp);
}
@end
