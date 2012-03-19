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

int main(int argc, const char * argv[]) {
    @autoreleasepool {        
        NSLog(@"Hello, World!");
    
        Http *http = [Http createServerWithIP:@"127.0.0.1" atPort:8000 callback:^(id a, id b) {
            NSLog(@"Accepted connection!\n");
        }];
        
        NSLog(@"http: %@", http);
        
        uv_run(uv_default_loop());
    }
    return 0;
}
