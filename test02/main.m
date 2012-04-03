//
//  main.m
//  test02
//
//  Created by Aldrin Martoq on 3/31/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Http.h"
#import "uv.h"


int fibonnacci(int n) {
    if (n < 2) {
        return 1;
    }
    return fibonnacci(n - 2) + fibonnacci(n - 1);
}

int main(int argc, const char * argv[]) {
    __block int count = 0;
    
    @autoreleasepool {
        Http *http = [Http createServerWithIP:@"127.0.0.1" atPort:8888 callback:^(Request *req, Response *res) {
            if ([req.url hasPrefix:@"/contar"]) {
                [res endWithBody:@"hello!"];
            } else {
                NSString *string = [NSString stringWithFormat:@"hola flaite numero %d fib 40 es %d\n", count++, fibonnacci(1)];
                [res endWithBody:string];
            }
        }];
        
        NSLog(@"http: %@", http);
        uv_run(uv_default_loop());
    }
    return 0;
}

