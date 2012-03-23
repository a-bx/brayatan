//
//  common.h
//  Brayatan
//
//  Created by Aldrin Martoq on 3/21/12.
//  Copyright (c) 2012 A0. All rights reserved.
//

#ifndef Brayatan_common_h
#define Brayatan_common_h

#import "uv.h"
#import "http_parser.h"


typedef struct {
    uv_tcp_t handle;
    http_parser parser;
    void *http;
    void *request;
    void *response;
    BOOL was_header_field;
    BOOL was_header_value;
    void *last_header_field;
} client_t;



#endif
