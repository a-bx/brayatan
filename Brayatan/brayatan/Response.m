//
//  Response.m
//  brayatan
//
//  Created by Aldrin Martoq on 3/21/12.
//  Copyright (c) 2012 A0. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

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
