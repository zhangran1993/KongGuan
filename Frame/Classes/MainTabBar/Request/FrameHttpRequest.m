//
//  FrameHttpRequest.m
//  Frame
//
//  Created by Hibaysoft on 17/7/4.
//  Copyright (c) 2018年 Hibaysoft. All rights reserved.
//

#import "FrameHttpRequest.h"
#import <AFNetworking.h>

@interface FrameHttpRequest ()

@property (nonatomic,strong) AFHTTPSessionManager * manager;

@end

@implementation FrameHttpRequest

/* manager 懒加载 */
- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}


+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    // 1.获得请求管理者//通过默认配置初始化Session
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    // 2.申明返回的结果是text/html类型
    //mgr.responseSerializer = [AFHTTPResponseSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer.HTTPShouldHandleCookies = YES;
    //[mgr.requestSerializer setValue:@"test" forHTTPHeaderField:@"requestHeader"];
    //mgr.requestSerializer.timeoutInterval = 60;
    //mgr.requestSerializer.stringEncoding = NSUTF8StringEncoding;//NSUTF8StringEncoding;
    mgr.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/JavaScript", @"text/json", @"text/html", nil];
    // 3.发送GET请求
    [mgr GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if(![[NSString stringWithFormat:@"%@",[responseObject objectForKey:@"errCode"]]  isEqual: @"0"]){
            NSLog(@"get请求失败%@",[responseObject objectForKey:@"errMsg"]);
            return ;
        }
        NSDictionary *response = [responseObject objectForKey:@"value"];
        
        if (success) {
            success(response);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];

}



+ (void)newget:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSURLSessionDataTask *))failure
{
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    mgr.requestSerializer.HTTPShouldHandleCookies = YES;
    
    // 3.发送GET请求
    [mgr GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSDictionary *response = [responseObject objectForKey:@"value"];
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSHTTPURLResponse * responses = (NSHTTPURLResponse *)task.response;
        NSLog(@"newget statusCode %ld  url %@",(long)responses.statusCode,url);
        NSLog(@"newget error    %@",error);
        
        if (failure) {
            failure(task);
        }
    }];
    
}
+(void)delete:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    // 获得请求管理者
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer.HTTPShouldHandleCookies = YES;
    [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    // 设置请求格式
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    [session DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
    }];
}

- (void)post:(NSString *)url params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    
    
    // 获得请求管理者
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    session.requestSerializer.HTTPShouldHandleCookies = YES;
    [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    // 设置请求格式
    session.requestSerializer = [AFJSONRequestSerializer serializer];
    //[session.requestSerializer requestWithMethod:@"POST" URLString:url parameters:params error:nil];
    [session POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPCookieStorage* cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray<NSHTTPCookie *> *cookies = [cookieStorage cookiesForURL:[NSURL URLWithString:WebNewHost]];
        
        
        //获取cookie

        NSArray*cookies1 = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];

        //把cookie进行归档并转换为NSData类型

        NSData*cookiesData = [NSKeyedArchiver archivedDataWithRootObject:cookies1];

        //存储归档后的cookie

        NSUserDefaults*userDefaults = [NSUserDefaults standardUserDefaults];

        [userDefaults setObject: cookiesData forKey:@"cookie"];

//        if ([UserManager shareUserManager].cookieArray.count == 0) {
//            [UserManager shareUserManager].cookieArray = cookies1;
//        }else {
//            
//            if (![[UserManager shareUserManager].cookieArray isEqualToArray:cookies1]) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeCookies" object:self];
//            }
//        }
        
        
        
        //NSMutableArray<NSDictionary *> *propertiesList = [[NSMutableArray alloc] init];
        [cookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull cookie, NSUInteger idx, BOOL * _Nonnull stop) {
            NSMutableDictionary *properties = [[cookie properties] mutableCopy];
            //将cookie过期时间设置为一年后
            NSDate *expiresDate = [NSDate dateWithTimeIntervalSinceNow:3600*24*30*12];
            properties[NSHTTPCookieExpires] = expiresDate;
            //下面一行是关键,删除Cookies的discard字段，应用退出，会话结束的时候继续保留Cookies
            [properties removeObjectForKey:NSHTTPCookieDiscard];
            //重新设置改动后的Cookies
            [cookieStorage setCookie:[NSHTTPCookie cookieWithProperties:properties]];
        }];
        
        if (success) {
            success(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"post error :%@",error);
        if (failure) {
            failure(error);
        }
    }];
    
}
+ (void)put:(NSString *)url params:(NSDictionary *)params success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    
    manager.requestSerializer.HTTPShouldHandleCookies = YES;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/javascript",@"text/json",@"text/plain", nil];
    
    // 设置请求头
    //[manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[manager.requestSerializer setValue:api_key forHTTPHeaderField:@"api_key"];
    [manager PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
