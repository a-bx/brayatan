//
//  main.m
//  test01
//
//  Created by Aldrin Martoq on 3/26/12.
//  Copyright (c) 2012 A0. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//  
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//  
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

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
