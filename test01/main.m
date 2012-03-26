//
//  main.m
//  test01
//
//  Created by Aldrin Martoq on 3/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
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

Http *multicore() {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    Http *http = [Http createServerWithIP:@"127.0.0.1" atPort:8000 callback:^(Request *req, Response *res) {
        dispatch_async(queue, ^{
            res.status = 200;
            [res.headers setObject:@"Content-type" forKey:@"text/plain"];
            [res endWithBody:[NSString stringWithFormat:@"Hello Client number %d fibonnaci is: %d\n", count++, fibonnacci(1)]];
        });
    }];
    
    return http;
}

Http *singlecore() {
    Http *http = [Http createServerWithIP:@"127.0.0.1" atPort:8000 callback:^(Request *req, Response *res) {
        res.status = 200;
        [res.headers setObject:@"Content-type" forKey:@"text/plain"];
        [res endWithBody:[NSString stringWithFormat:@"Hello Client number %d fibonnaci is: %d\n", count++, fibonnacci(1)]];
    }];
    
    return http;
}


int main(int argc, const char * argv[]) {
    @autoreleasepool {        
        Http *http = singlecore();
        
        NSLog(@"Hello flaites, http: %@", http);
        uv_run(uv_default_loop());
    }
    return 0;
}
