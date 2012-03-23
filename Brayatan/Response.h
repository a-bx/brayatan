//
//  Response.h
//  Brayatan
//
//  Created by Aldrin Martoq on 3/21/12.
//  Copyright (c) 2012 A0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "common.h"


@interface Response : NSObject {
    client_t *client;
}

@property (retain, nonatomic) NSMutableDictionary *headers;
@property (nonatomic) int status;

- (id)initWithClient:(client_t*) client;
- (BOOL)endWithBody:(NSString *)body;

@end
