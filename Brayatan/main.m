//
//  main.m
//  Brayatan
//
//  Created by Aldrin Martoq on 3/18/12.
//  Copyright (c) 2012 A0. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Http.h"
#import "uv.h"

static int count = 0;
int main(int argc, const char * argv[]) {
    @autoreleasepool {        
        NSLog(@"Hello, World!");
    
//        __block int count = 0;
        
        Http *http = [Http createServerWithIP:@"127.0.0.1" atPort:8000 callback:^(Request *req, Response *res) {
            //NSLog(@"Accepted connection for user-agent: %@!\n", [req.headers objectForKey:@"User-Agent"]);
            res.status = 200;
            [res.headers setObject:@"Content-type" forKey:@"text/plain"];
            [res endWithBody:[NSString stringWithFormat:@"Hello Client number %d!\n", count++]];
        }];
        
        NSLog(@"http: %@", http);
        
        uv_run(uv_default_loop());
    }
    return 0;
}
