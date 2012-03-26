//
//  Request.m
//  Brayatan
//
//  Created by Aldrin Martoq on 3/19/12.
//  Copyright (c) 2012 A0. All rights reserved.
//

#import "Request.h"

@implementation Request

@synthesize headers;

- (id) init {
    if (self = [super init]) {
        headers = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

@end
