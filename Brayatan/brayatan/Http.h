//
//  Http.h
//  Brayatan
//
//  Created by Aldrin Martoq on 3/18/12.
//  Copyright (c) 2012 A0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Request.h"
#import "Response.h"
#import "brayatan-common.h"

@interface Http : NSObject {
    uv_tcp_t *uv_tcp;
    void (^callback)(Request *req, Response *res);
}

- (void) invokeReq:(Request *)req invokeRes:(Response *)res;
+ (Http *) createServerWithIP:(NSString *)ip atPort:(int)port callback:(void (^)(Request *req, Response *res))callback;

@end
