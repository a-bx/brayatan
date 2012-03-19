//
//  Http.h
//  Brayatan
//
//  Created by Aldrin Martoq on 3/18/12.
//  Copyright (c) 2012 A0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "uv.h"
#import "http_parser.h"

@interface Http : NSObject {
    uv_tcp_t *uv_tcp;
}

+ (Http *) createServerWithIP:(NSString *)ip atPort:(int)port callback:(void (^)(id a, id b))callback;

@end
