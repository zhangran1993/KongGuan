//
//  WYLHTTPSessionManager.m
//
//  Created by 王云龙 on 15/12/6.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import "WYLHTTPSessionManager.h"

@implementation WYLHTTPSessionManager


- (instancetype)initWithBaseURL:(NSURL *)url sessionConfiguration:(NSURLSessionConfiguration *)configuration
{
    if (self = [super initWithBaseURL:url sessionConfiguration:configuration]) {
    
        // 'application/x-www-form-urlencoded;charset=UTF-8' not supported" 转换请求方式application/json
        //转变原来的http请求方式为json请求方式
        //原来requestSerializer是AFHTTPRequestSerializer的实例，现在把它改为AFJSONRequestSerializer的实例就解决了这个问题。
        
        //1.先设置上传数据格式
        self.requestSerializer = [AFJSONRequestSerializer serializer];
        //2.然后设置请求头
        //将token封装入请求头
        // 设置超时时间
        [self.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        self.requestSerializer.timeoutInterval = 30.0f;
        [self.requestSerializer didChangeValueForKey:@"timeoutInterval"];
        

    }

    
    return self;
}
- (void)addCookie {
    
    // Cookie dictionart
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionaryWithCapacity:3];
    
    //进行拼接
    NSString *token = ObtainToken;
    NSString *sessionId = ObtainJSHSessionId;
    NSString *rememberMe = ObtainRememberMe;
    NSMutableString *cookieValue = [NSMutableString string];
    
    if (sessionId) {
        [cookieValue appendFormat:@"JSESSIONID=%@;",sessionId];
    }
    
    if (rememberMe) {
        [cookieValue appendFormat:@"jsh-remember-me=%@;",rememberMe];
    }
    
    if (token){
        [cookieValue appendFormat:@"token=%@;",token];
    }
    
    if ([cookieValue hasSuffix:@";"]){
        [cookieValue deleteCharactersInRange:NSMakeRange(cookieValue.length - 1, 1)];
    }
    
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (NSHTTPCookie *cookie in [cookieJar cookies]){
        [cookieDic setObject:cookie.value forKey:cookie.name];
    }
    
    [self.requestSerializer setValue:cookieValue forHTTPHeaderField:@"Cookie"];
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"accept"];
    [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"content-type"];
}


- (NSString * )getCookieValue{
    
    
    
    //进行拼接
    NSString *token = ObtainToken;
    NSString *sessionId = ObtainJSHSessionId;
    NSString *rememberMe = ObtainRememberMe;
    NSMutableString *cookieValue = [NSMutableString string];
    
    if (sessionId) {
        [cookieValue appendFormat:@"JSESSIONID=%@;",sessionId];
    }
    
    if (rememberMe) {
        [cookieValue appendFormat:@"jsh-remember-me=%@;",rememberMe];
    }
    
    if (token){
        [cookieValue appendFormat:@"token=%@;",token];
    }
    
    if ([cookieValue hasSuffix:@";"]){
        [cookieValue deleteCharactersInRange:NSMakeRange(cookieValue.length - 1, 1)];
    }
    
    return cookieValue;
    
}
@end
