//
//  Response.m
//  Brayatan
//
//  Created by Aldrin Martoq on 3/21/12.
//  Copyright (c) 2012 A0. All rights reserved.
//

#import "Response.h"

void on_after_write(uv_write_t* req, int status) {
    free(req);
}

void dowrite(client_t *client, NSString *string) {
    uv_write_t *write_req = malloc(sizeof(uv_write_t));
    uv_buf_t write_buf;
    write_buf.len = [string lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    write_buf.base = (char *)[string cStringUsingEncoding:NSUTF8StringEncoding];
    uv_write(write_req, (uv_stream_t*)&client->handle, &write_buf, 1, on_after_write);
}

@implementation Response

@synthesize headers;
@synthesize status;

- (id) initWithClient:(client_t*)c {
    if (self = [super init]) {
        headers = [[NSMutableDictionary alloc] init];
        client = c;
    }
         return self;
}

- (BOOL)endWithBody:(NSString *)body {
    NSMutableString *tmp = [[NSMutableString alloc] init];

    [tmp appendFormat:@"HTTP/1.1 %d %@\r\n", status, @"OK"];
    for (id key in headers) {
        [tmp appendFormat:@"%@: %@\r\n", key, [headers objectForKey:key]];
    }
    [tmp appendFormat:@"\r\n"];
    [tmp appendFormat:body];
    dowrite(client, tmp);
    
    uv_close((uv_handle_t*)&client->handle, on_close);
    return YES;
}

@end
