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

int fibonnacci(int n) {
    if (n < 2) {
        return 1;
    }
    return fibonnacci(n - 2) + fibonnacci(n - 1);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {        
        NSLog(@"Hello, World!");
        
        Http *http = [Http createServerWithIP:@"127.0.0.1" atPort:8000 callback:^(Request *req, Response *res) {
            res.status = 200;
            [res.headers setObject:@"Content-type" forKey:@"text/plain"];
            [res endWithBody:[NSString stringWithFormat:@"Hello Client number %d fibonnaci is: %d\n", count++, fibonnacci(20)]];
        }];

        NSLog(@"http: %@", http);

        uv_run(uv_default_loop());
    }
    return 0;
}
