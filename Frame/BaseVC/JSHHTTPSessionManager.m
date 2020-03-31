//
//  JSHHTTPSessionManager.m
//  ylh-app-primary-ios
//
//  Created by 巨商汇 on 2018/9/9.
//  Copyright © 2018年 巨商汇. All rights reserved.
//

#import "JSHHTTPSessionManager.h"

@implementation JSHHTTPSessionManager


- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    if (self = [super initWithBaseURL:url sessionConfiguration:configuration]) {
        
        
        // 'application/x-www-form-urlencoded;charset=UTF-8' not supported" 转换请求方式application/json
        //转变原来的http请求方式为json请求方式
        //原来requestSerializer是AFHTTPRequestSerializer的实例，现在把它改为AFJSONRequestSerializer的实例就解决了这个问题。
        
        //1.先设置上传数据格式
        self.requestSerializer = [AFHTTPRequestSerializer serializer];
        //2.然后设置请求头
        //将token封装入请求头
        // 设置超时时间
        [self.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        self.requestSerializer.timeoutInterval = 30.0f;
        [self.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        
        //        self.securityPolicy = ...;
        //        [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        //        [self.requestSerializer setValue:@"multipart/form-data;" forHTTPHeaderField:@"Content-Type"];
        //        self.responseSerializer.acceptableContentTypes = [self.responseSerializer.acceptableContentTypes setByAddingObject: @"text/html"];
        //        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain",@"text/json", @"text/javascript",@"text/html", nil];
        
    }
    return self;
}

@end
