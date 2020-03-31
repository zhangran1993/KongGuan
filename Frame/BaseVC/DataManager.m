//
//  DataManager.m
//  ylh-app-primary-ios
//
//  Copyright © 2018年 巨商汇. All rights reserved.
//

#import "DataManager.h"


static DataManager *_manager;

@interface DataManager ()

/** 网络请求管理者 */
@property(nonatomic , strong) WYLHTTPSessionManager *afnManager;

/** 前后端串联字符串 */
@property(nonatomic , copy) NSString *jsh_page_name;

@end


@implementation DataManager

/**  懒加载  */
-(WYLHTTPSessionManager *)afnManager{
    if (_afnManager == nil) {
        _afnManager = [WYLHTTPSessionManager manager];
    }
    NSString * token = ObtainToken;
    

    [_afnManager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    [_afnManager.requestSerializer setValue:self.jsh_page_name forHTTPHeaderField:@"jsh-page-name"];
    _afnManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", @"application/atom+xml", @"application/x-www-form-urlencoded", @"application/xml", @"text/xml", nil];
    [_afnManager addCookie];
    return _afnManager;
}

+(instancetype)sharedManager{
    return  [[self alloc]init];
}

+(instancetype)sharedManagerWithTimeoutInterval:(NSTimeInterval)timeoutInterval{
    DataManager *manager = [[self alloc]init];
    [manager.afnManager.requestSerializer setTimeoutInterval:timeoutInterval];
    return manager;
}

+(instancetype)sharedManagerWithHeaderPara:(NSMutableDictionary *)para{
    DataManager *manager = [[self alloc]init];
    manager.jsh_page_name = [NSString convertToJsonData:para];
    return  manager;
}


+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    // 由于alloc方法内部会调用allocWithZone: 所以我们只需要保证在该方法只创建一个对象即可
    dispatch_once(&onceToken, ^{
        // 只执行1次的代码(这里面默认是线程安全的)
        _manager = [super allocWithZone:zone];
        
    });
    return _manager;
}

//因为copy方法必须通过实例对象调用, 所以可以直接返回_instance
-(id)copyWithZone:(NSZone *)zone
{
    return _manager;
}

-(id)mutableCopyWithZone:(NSZone *)zone
{
    return _manager;
}

/**
 *  处理字符串将其转成标准json格式
 *
 *  @param data 响应数据
 *
 *  @return id
 */
-(id)handleResponseObject:(NSData *)data {
    
    //将获取的二进制数据转成字符串
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //去掉字符串里的转义字符
    NSString *str1 = [str stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    //去掉头和尾的引号“”
    NSString *str2 = [str1 substringWithRange:NSMakeRange(1, str1.length-2)];
    //最终str2为json格式的字符串，将其转成需要的字典和数组
    id object = [self jsonStringConvertToJosnClassWithJsonString:str2];
    
    return object;
}

- (id)jsonStringConvertToJosnClassWithJsonString:(NSString *)jsonString
{
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    id jsonClass = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    return jsonClass;
}



/**
 *  提示信息
 *
 *  @param message 要提示的内容
 */
+ (void)showAlertViewWithMessage:(NSString *)message {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alertView show];
}

//GET请求
- (void)getDataWithUrl:(NSString *)url parameters:(id)parameters success:(Success)success failure:(Failure)failure {
    NSLog(@"接口URL:%@",url);
    
    
    id newParameters = parameters;
    
    if ([parameters isKindOfClass:[NSDictionary class]] || [parameters isKindOfClass:[NSMutableDictionary class]]) {
        
        /** para包含
         funcCode 产品的编码;
         className 控制器类名;
         funcName 方法名;
         platform; IOS **/
        
        if (isNonemptyString(parameters[@"funcCode"]) && isNonemptyString(parameters[@"className"]) && isNonemptyString(@"funcName")) {
            NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
            
            NSMutableDictionary * para = [NSMutableDictionary dictionary];
            para[@"funcCode"] = parameters[@"funcCode"];
            para[@"className"] = parameters[@"className"];
            para[@"funcName"] = parameters[@"funcName"];
            para[@"platform"] = @"IOS";
            self.jsh_page_name = [NSString convertToJsonData:para];
            
            [dict removeObjectsForKeys:@[@"funcCode",@"className",@"funcName"]];
            newParameters = dict;
        }
        
        
    }

    
    
    [self.afnManager GET:url parameters:newParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         /*注意:这里要强转下*/
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;
        NSArray * allCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie * cookies in allCookies) {
            if ([cookies.name isEqualToString:@"token"]) {
                NSString * token = [NSString stringWithFormat:@"bearer %@",cookies.value];
                SaveToken(token);
                
                NSString *authorization = [NSString stringWithFormat:@"\"%@\"",token];
                SaveAuthorization(authorization);
            }
            
            if ([cookies.name isEqualToString:@"JSESSIONID"]) {
                NSString *jsh_session_id = [NSString stringWithFormat:@"\"%@\"",cookies.value];
//                NSLog(@"+++++JSHSessionId=%@+++++",cookies.value);
                
                if (![NSString isBlankString:jsh_session_id]) {
                     SaveJSHSessionId(jsh_session_id);
                }
                
               
            }
            
            if ([cookies.name isEqualToString:@"jsh-remember-me"]) {
                NSString *jsh_remember_me = [NSString stringWithFormat:@"\"%@\"",cookies.value];
//                NSLog(@"++++++RememberMe=%@+++++",cookies.value);
                if (![NSString isBlankString:jsh_remember_me]) {
                     SaveRememberMe(jsh_remember_me);
                }
            }

        }
        NSString *access_token = allHeaders[@"access_token"];
        if (isNonemptyString(access_token)) {
            NSString *token = [NSString stringWithFormat:@"bearer %@",access_token];

            SaveToken(token);
        }

        if (success) {
            success(responseObject);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      
        if (error) {
            failure(error);
        }
    }];
    
}

//POST请求
- (void)postDataWithUrl:(NSString *)url parameters:(id)parameters success:(Success)success failure:(Failure)failure {
    NSLog(@"接口URL:%@",url);
    
    id newParameters = parameters;
    
    if ([parameters isKindOfClass:[NSDictionary class]] || [parameters isKindOfClass:[NSMutableDictionary class]]) {
        
        /** para包含
         funcCode 产品的编码;
         className 控制器类名;
         funcName 方法名;
         platform; IOS **/
        
        if (isNonemptyString(parameters[@"funcCode"]) && isNonemptyString(parameters[@"className"]) && isNonemptyString(@"funcName")) {
            NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
            
            NSMutableDictionary * para = [NSMutableDictionary dictionary];
            para[@"funcCode"] = parameters[@"funcCode"];
            para[@"className"] = parameters[@"className"];
            para[@"funcName"] = parameters[@"funcName"];
            para[@"platform"] = @"IOS";
            self.jsh_page_name = [NSString convertToJsonData:para];
            
            [dict removeObjectsForKeys:@[@"funcCode",@"className",@"funcName"]];
            newParameters = dict;
        }
        
        
    }

    
    [self.afnManager POST:url parameters:newParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;
            
        NSArray * allCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie * cookies in allCookies) {
            if ([cookies.name isEqualToString:@"token"]) {
                NSString * token = [NSString stringWithFormat:@"bearer %@",cookies.value];
                SaveToken(token);
            }
            
            if ([cookies.name isEqualToString:@"JSESSIONID"]) {
                NSString *jsh_session_id = [NSString stringWithFormat:@"\"%@\"",cookies.value];
                
                if (![NSString isBlankString:jsh_session_id]) {
                    SaveJSHSessionId(jsh_session_id);
                }
            }
            
            
            if ([cookies.name isEqualToString:@"jsh-remember-me"]) {
                NSString *jsh_remember_me = [NSString stringWithFormat:@"\"%@\"",cookies.value];
                
                if (![NSString isBlankString:jsh_remember_me]) {
                    SaveRememberMe(jsh_remember_me);
                }
            }
            
            
        }
    

        NSString *access_token = allHeaders[@"access_token"];
        if (isNonemptyString(access_token)) {
            NSString *token = [NSString stringWithFormat:@"bearer %@",access_token];
            
            SaveToken(token);
            
            NSString *authorization = [NSString stringWithFormat:@"\"%@\"",token];
            SaveAuthorization(authorization);
        }
        
        
        if(isNonemptyString(responseObject[@"errorMsg"])){
            [MBProgressHUD hideHUDForView:JSHmainWindow];
           
//            [MBProgressHUD showError:responseObject[@"errorMsg"] toView:JSHmainWindow];
            
        }
        
        
        if (success) {
            success(responseObject);
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error) {
           
            failure(error);
        }
    }];
}



/**
 *  POST请求  不自动提示错误信息
 *
 *  @param url       NSString 请求url
 *  @param parameters NSDictionary 参数
 *  @param success   void(^Success)(id json)回调
 *  @param failure   void(^Failure)(NSError *error)回调
 */
- (void)lc_postDataWithUrl:(NSString *)url parameters:(id)parameters success:(Success)success failure:(Failure)failure {
    NSLog(@"接口URL:%@",url);
    [self.afnManager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;
        
        NSArray * allCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie * cookies in allCookies) {
            if ([cookies.name isEqualToString:@"token"]) {
                NSString * token = [NSString stringWithFormat:@"bearer %@",cookies.value];
                SaveToken(token);
            }
            
            if ([cookies.name isEqualToString:@"JSESSIONID"]) {
                NSString *jsh_session_id = [NSString stringWithFormat:@"\"%@\"",cookies.value];
                
                if (![NSString isBlankString:jsh_session_id]) {
                    SaveJSHSessionId(jsh_session_id);
                }
            }
            
            
            if ([cookies.name isEqualToString:@"jsh-remember-me"]) {
                NSString *jsh_remember_me = [NSString stringWithFormat:@"\"%@\"",cookies.value];
                
                if (![NSString isBlankString:jsh_remember_me]) {
                    SaveRememberMe(jsh_remember_me);
                }
            }
            
            
        }
        
        
        NSString *access_token = allHeaders[@"access_token"];
        if (isNonemptyString(access_token)) {
            NSString *token = [NSString stringWithFormat:@"bearer %@",access_token];
            
            SaveToken(token);
            
            NSString *authorization = [NSString stringWithFormat:@"\"%@\"",token];
            SaveAuthorization(authorization);
        }

        
        if (success){
            success(responseObject);
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        //        NSDictionary *allHeaders = response.allHeaderFields;
        if (error) {
            
            failure(error);
        }
    }];
}



/** 试点接口 **/
- (void)getDataWithUrl:(NSString *)url parameters:(id)parameters isShowCustomAlert:(BOOL)isShow success:(Success)success failure:(Failure)failure{
    [self.afnManager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        /*注意:这里要强转下*/
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;
        NSArray * allCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie * cookies in allCookies) {
            if ([cookies.name isEqualToString:@"token"]) {
                NSString * token = [NSString stringWithFormat:@"bearer %@",cookies.value];
                SaveToken(token);
                
                NSString *authorization = [NSString stringWithFormat:@"\"%@\"",token];
                SaveAuthorization(authorization);
            }
            
            if ([cookies.name isEqualToString:@"JSESSIONID"]) {
                NSString *jsh_session_id = [NSString stringWithFormat:@"\"%@\"",cookies.value];
                //                NSLog(@"+++++JSHSessionId=%@+++++",cookies.value);
                
                if (![NSString isBlankString:jsh_session_id]) {
                    SaveJSHSessionId(jsh_session_id);
                }
                
                
            }
            
            if ([cookies.name isEqualToString:@"jsh-remember-me"]) {
                NSString *jsh_remember_me = [NSString stringWithFormat:@"\"%@\"",cookies.value];
                //                NSLog(@"++++++RememberMe=%@+++++",cookies.value);
                if (![NSString isBlankString:jsh_remember_me]) {
                    SaveRememberMe(jsh_remember_me);
                }
            }
            
        }
        NSString *access_token = allHeaders[@"access_token"];
        if (isNonemptyString(access_token)) {
            NSString *token = [NSString stringWithFormat:@"bearer %@",access_token];
            
            SaveToken(token);
        }
        
        
        /*注意:这里要强转下*/
        if (response.statusCode == 200) {
            /** 请求成功,此时再判断success **/
            if ([responseObject[@"success"] boolValue] == true) {
                if (success) {
                    success(responseObject);
                }
            }else{
                if (isNonemptyString(responseObject[@"errorMsg"])) {
                    [MBProgressHUD hideHUDForView:JSHmainWindow];
                    [MBProgressHUD showError:responseObject[@"errorMsg"] toView:JSHmainWindow];
                }
                
                if (success) {
                    success(nil);
                }
                
            }
            
        }else{
            /** 服务器异常 **/
            NSString *requestId =  allHeaders[@"jsh-request-id"];
            if (isNonemptyString(requestId)) {
                /**  如果有requestId 则弹出requestId **/
                if ([requestId containsString:@","]) {
                    //分隔字符串
                    NSArray *array = [requestId componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
                    requestId = array.firstObject;
                }else{
                    
                }
                
            }else{
                /** 否则弹出服务器异常 **/
            }
            
            
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        /*注意:这里要强转下*/
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;
        
        /** 服务器异常 **/
        NSString *requestId =  allHeaders[@"jsh-request-id"];
        if (isNonemptyString(requestId)) {
            /**  如果有requestId 则弹出requestId **/
            if ([requestId containsString:@","]) {
                //分隔字符串
                NSArray *array = [requestId componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
                requestId = array.firstObject;
            }else{
                
            }
            
        }else{
            /** 否则弹出服务器异常 **/
        }
        
        
        
        if (error) {
            failure(error);
        }
    }];
}

- (void)postDataWithUrl:(NSString *)url parameters:(id)parameters isShowCustomAlert:(BOOL)isShow success:(Success)success failure:(Failure)failure{
    
    [self.afnManager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;
        
        NSArray * allCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie * cookies in allCookies) {
            if ([cookies.name isEqualToString:@"token"]) {
                NSString * token = [NSString stringWithFormat:@"bearer %@",cookies.value];
                SaveToken(token);
            }
            
            if ([cookies.name isEqualToString:@"JSESSIONID"]) {
                NSString *jsh_session_id = [NSString stringWithFormat:@"\"%@\"",cookies.value];
                
                if (![NSString isBlankString:jsh_session_id]) {
                    SaveJSHSessionId(jsh_session_id);
                }
            }
            
            
            if ([cookies.name isEqualToString:@"jsh-remember-me"]) {
                NSString *jsh_remember_me = [NSString stringWithFormat:@"\"%@\"",cookies.value];
                
                if (![NSString isBlankString:jsh_remember_me]) {
                    SaveRememberMe(jsh_remember_me);
                }
            }
            
            
        }
        
        
        NSString *access_token = allHeaders[@"access_token"];
        if (isNonemptyString(access_token)) {
            NSString *token = [NSString stringWithFormat:@"bearer %@",access_token];
            
            SaveToken(token);
            
            NSString *authorization = [NSString stringWithFormat:@"\"%@\"",token];
            SaveAuthorization(authorization);
        }
        
        
        if(isNonemptyString(responseObject[@"errorMsg"])){
            [MBProgressHUD hideHUDForView:JSHmainWindow];
            
            //            [MBProgressHUD showError:responseObject[@"errorMsg"] toView:JSHmainWindow];
            
        }
        
        
        /*注意:这里要强转下*/
        if (response.statusCode == 200) {
            /** 请求成功,此时再判断success **/
            if ([responseObject[@"success"] boolValue] == true) {
                if (success) {
                    success(responseObject);
                }
            }else{
                if (isNonemptyString(responseObject[@"errorMsg"])) {
                    [MBProgressHUD hideHUDForView:JSHmainWindow];
                    [MBProgressHUD showError:responseObject[@"errorMsg"] toView:JSHmainWindow];
                }
                if (success) {
                    success(nil);
                }
                
            }
        }else{
            /** 服务器异常 **/
            NSString *requestId =  allHeaders[@"jsh-request-id"];
            if (isNonemptyString(requestId)) {
                /**  如果有requestId 则弹出requestId **/
                if ([requestId containsString:@","]) {
                    //分隔字符串
                    NSArray *array = [requestId componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
                    requestId = array.firstObject;
                }else{
                    
                }
                
            }else{
                /** 否则弹出服务器异常 **/
            }
            
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        /*注意:这里要强转下*/
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;
        
        /** 服务器异常 **/
        NSString *requestId =  allHeaders[@"jsh-request-id"];
        if (isNonemptyString(requestId)) {
            /**  如果有requestId 则弹出requestId **/
            if ([requestId containsString:@","]) {
                //分隔字符串
                NSArray *array = [requestId componentsSeparatedByString:@","]; //从字符A中分隔成2个元素的数组
                requestId = array.firstObject;
            }else{
                
            }
            
        }else{
            /** 否则弹出服务器异常 **/
        }
        
        if (error) {
            
            failure(error);
        }
    }];
    
}
/** 试点接口 **/



//MAKR:单图片上传
-(void)postDataWithUrl:(NSString *)url parameters:(id)parameters image:(UIImage *)image success:(Success)success failure:(Failure)failure{
    NSLog(@"接口URL:%@",url);
    
    
    id newParameters = parameters;
    
    if ([parameters isKindOfClass:[NSDictionary class]] || [parameters isKindOfClass:[NSMutableDictionary class]]) {
        
        /** para包含
         funcCode 产品的编码;
         className 控制器类名;
         funcName 方法名;
         platform; IOS **/
        
        if (isNonemptyString(parameters[@"funcCode"]) && isNonemptyString(parameters[@"className"]) && isNonemptyString(@"funcName")) {
            NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithDictionary:parameters];
            
            NSMutableDictionary * para = [NSMutableDictionary dictionary];
            para[@"funcCode"] = parameters[@"funcCode"];
            para[@"className"] = parameters[@"className"];
            para[@"funcName"] = parameters[@"funcName"];
            para[@"platform"] = @"IOS";
            self.jsh_page_name = [NSString convertToJsonData:para];
            
            [dict removeObjectsForKeys:@[@"funcCode",@"className",@"funcName"]];
            newParameters = dict;
        }
        
        
    }
    
    
    [self.afnManager POST:url parameters:newParameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //将图片摆正
        UIImage *newImage = [UIImage fixOrientation:image];
        
        NSData *imageData = UIImageJPEGRepresentation(newImage, 0.5);
        
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题，
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
        /*
         *该方法的参数
         1. appendPartWithFileData：要上传的照片[二进制流]
         2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
         3. fileName：要保存在服务器上的文件名
         4. mimeType：上传的文件的类型
         */
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"]; //
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;
      
        
        NSArray * allCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie * cookies in allCookies) {
            if ([cookies.name isEqualToString:@"token"]) {
                NSString * token = [NSString stringWithFormat:@"bearer %@",cookies.value];
                SaveToken(token);
                
                NSString *authorization = [NSString stringWithFormat:@"\"%@\"",token];
                SaveAuthorization(authorization);
            }
            
            
            if ([cookies.name isEqualToString:@"JSESSIONID"]) {
                NSString *jsh_session_id = [NSString stringWithFormat:@"\"%@\"",cookies.value];
                
                if (![NSString isBlankString:jsh_session_id]) {
                    SaveJSHSessionId(jsh_session_id);
                }
            }
            
            
            if ([cookies.name isEqualToString:@"jsh-remember-me"]) {
                NSString *jsh_remember_me = [NSString stringWithFormat:@"\"%@\"",cookies.value];
                
                if (![NSString isBlankString:jsh_remember_me]) {
                    SaveRememberMe(jsh_remember_me);
                }
            }
            
            
        }
        
        NSString *access_token = allHeaders[@"access_token"];
        if (isNonemptyString(access_token)) {
            NSString *token = [NSString stringWithFormat:@"bearer %@",access_token];
            
            SaveToken(token);
        }
        
        
        if(isNonemptyString(responseObject[@"errorMsg"])){
            [MBProgressHUD hideHUDForView:JSHmainWindow];
            [MBProgressHUD showError:responseObject[@"errorMsg"] toView:JSHmainWindow];
            
            if (success) {
                success(nil);
                
            }
        } else {
            if (success) {
                success(responseObject);
                
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            
            failure(error);
        }
    }];
}

//MAKR:多图片上传
-(void)postImageDataWithUrl:(NSString *)url parameters:(id)parameters imageArray:(NSArray *)imageArray success:(Success)success failure:(Failure)failure{
    NSLog(@"接口URL:%@",url);
    [self.afnManager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        
        for (UIImage *image in imageArray) {
            
            //将图片摆正
            UIImage *newImage = [UIImage fixOrientation:image];
            
            //压缩上传图片
            NSData *imageData = UIImageJPEGRepresentation(newImage, 0.5);
            
            //随机生成32位字符串
            NSString *string = [[NSString alloc]init];
            for (int i = 0; i < 32; i++) {
                int number = arc4random() % 36;
                if (number < 10) {
                    int figure = arc4random() % 10;
                    NSString *tempString = [NSString stringWithFormat:@"%d", figure];
                    string = [string stringByAppendingString:tempString];
                }else {
                    int figure = (arc4random() % 26) + 97;
                    char character = figure;
                    NSString *tempString = [NSString stringWithFormat:@"%c", character];
                    string = [string stringByAppendingString:tempString];
                }
            }
            
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", string];
            
            /*
             *该方法的参e数
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
            [formData appendPartWithFileData:imageData name:@"files" fileName:fileName mimeType:@"image/jpeg"]; //
            
            
        }
        
        
       
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;
        
        
        NSArray * allCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie * cookies in allCookies) {
            if ([cookies.name isEqualToString:@"token"]) {
                NSString * token = [NSString stringWithFormat:@"bearer %@",cookies.value];
                SaveToken(token);
                
                NSString *authorization = [NSString stringWithFormat:@"\"%@\"",token];
                SaveAuthorization(authorization);
            }
            
            
            if ([cookies.name isEqualToString:@"JSESSIONID"]) {
                NSString *jsh_session_id = [NSString stringWithFormat:@"\"%@\"",cookies.value];
                
                if (![NSString isBlankString:jsh_session_id]) {
                    SaveJSHSessionId(jsh_session_id);
                }
            }
            
            
            if ([cookies.name isEqualToString:@"jsh-remember-me"]) {
                NSString *jsh_remember_me = [NSString stringWithFormat:@"\"%@\"",cookies.value];
                
                if (![NSString isBlankString:jsh_remember_me]) {
                    SaveRememberMe(jsh_remember_me);
                }
            }
            
            
        }
        
        NSString *access_token = allHeaders[@"access_token"];
        if (isNonemptyString(access_token)) {
            NSString *token = [NSString stringWithFormat:@"bearer %@",access_token];
            
            SaveToken(token);
        }
        
        
        if(isNonemptyString(responseObject[@"errorMsg"])){
            [MBProgressHUD hideHUDForView:JSHmainWindow];
            [MBProgressHUD showError:responseObject[@"errorMsg"] toView:JSHmainWindow];
            
            if (success) {
                success(nil);
                
            }
        } else {
            if (success) {
                success(responseObject);
                
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            
            failure(error);
        }
    }];
}

- (void)deleteDataWithUrl:(NSString *)url parameters:(id)parameters success:(Success)success failure:(Failure)failure{
    NSLog(@"接口URL:%@",url);
    [self.afnManager DELETE:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;
        
        NSArray * allCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie * cookies in allCookies) {
            if ([cookies.name isEqualToString:@"token"]) {
                NSString * token = [NSString stringWithFormat:@"bearer %@",cookies.value];
                SaveToken(token);
            }
            
            if ([cookies.name isEqualToString:@"JSESSIONID"]) {
                NSString *jsh_session_id = [NSString stringWithFormat:@"\"%@\"",cookies.value];
                
                if (![NSString isBlankString:jsh_session_id]) {
                    SaveJSHSessionId(jsh_session_id);
                }
            }
            
            
            if ([cookies.name isEqualToString:@"jsh-remember-me"]) {
                NSString *jsh_remember_me = [NSString stringWithFormat:@"\"%@\"",cookies.value];
                
                if (![NSString isBlankString:jsh_remember_me]) {
                    SaveRememberMe(jsh_remember_me);
                }
            }
            
            
        }
        
        
        NSString *access_token = allHeaders[@"access_token"];
        if (isNonemptyString(access_token)) {
            NSString *token = [NSString stringWithFormat:@"bearer %@",access_token];
            
            SaveToken(token);
            
            NSString *authorization = [NSString stringWithFormat:@"\"%@\"",token];
            SaveAuthorization(authorization);
        }
        
        
        if(isNonemptyString(responseObject[@"errorMsg"])){
            [MBProgressHUD hideHUDForView:JSHmainWindow];
            
            [MBProgressHUD showError:responseObject[@"errorMsg"] toView:JSHmainWindow];
            
        }
        
        if (success){
            success(responseObject);
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        //        NSDictionary *allHeaders = response.allHeaderFields;
        if (error) {
            
            failure(error);
        }
    }];
}

/** 取消请求 **/
- (void)cancelAllRequests
{
    //取消所有请求
    [self.afnManager invalidateSessionCancelingTasks:YES];
    
}


/** 取消单次请求 **/
- (void)cancleSingleRequests{
    //进行下拉刷新的时候,取消上拉刷新发送的网络请求
    [self.afnManager.tasks makeObjectsPerformSelector:@selector(cancel)];
}



#pragma mark - RS_DataManager
// 上传图片
-(void)rs_uploadImageWithUrl:(NSString *)url parameters:(id)parameters image:(UIImage *)image success:(Success)success failure:(Failure)failure {
    NSLog(@"接口URL:%@",url);
    WYLHTTPSessionManager *manager = [WYLHTTPSessionManager manager];
    NSString *token = ObtainToken;
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //将图片摆正
        UIImage *newImage = [UIImage fixOrientation:image];
        NSData *imageData = UIImageJPEGRepresentation(newImage, 0.5);
        
        NSString *fileName = [[self random_32_String] stringByAppendingString:@".jpg"];
        
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;
        

        NSArray * allCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie * cookies in allCookies) {
            if ([cookies.name isEqualToString:@"token"]) {
                NSString * token = [NSString stringWithFormat:@"bearer %@",cookies.value];
                SaveToken(token);
                
                NSString *authorization = [NSString stringWithFormat:@"\"%@\"",token];
                SaveAuthorization(authorization);
            }
            
            
            if ([cookies.name isEqualToString:@"JSESSIONID"]) {
                NSString *jsh_session_id = [NSString stringWithFormat:@"\"%@\"",cookies.value];
                
                if (![NSString isBlankString:jsh_session_id]) {
                    SaveJSHSessionId(jsh_session_id);
                }
            }
            
            
            if ([cookies.name isEqualToString:@"jsh-remember-me"]) {
                NSString *jsh_remember_me = [NSString stringWithFormat:@"\"%@\"",cookies.value];
                
                if (![NSString isBlankString:jsh_remember_me]) {
                    SaveRememberMe(jsh_remember_me);
                }
            }
            
            
        }
        
        NSString *access_token = allHeaders[@"access_token"];
        if (isNonemptyString(access_token)) {
            NSString *token = [NSString stringWithFormat:@"bearer %@",access_token];
            
            SaveToken(token);
        }
        
        
        if(isNonemptyString(responseObject[@"errorMsg"])){
            [MBProgressHUD hideHUDForView:JSHmainWindow];
            [MBProgressHUD showError:responseObject[@"errorMsg"] toView:JSHmainWindow];
            
            if (success) {
                success(nil);
                
            }
        } else {
            if (success) {
                success(responseObject);
                
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            
            failure(error);
        }
    }];
}

// 上传视频
- (void)postVideoWithUrl:(NSString *)url parameters:(id)parameters video:(NSData *)videoData fileName:(NSString *)fileName success:(Success)success failure:(Failure)failure {
    NSLog(@"接口URL:%@",url);
    WYLHTTPSessionManager *manager = [WYLHTTPSessionManager manager];
    NSString *token = ObtainToken;
    [manager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    manager.completionQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        /*
         *该方法的参e数
         1. appendPartWithFileData：要上传的视频[二进制流]
         2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
         3. fileName：要保存在服务器上的文件名
         4. mimeType：上传的文件的类型
         */
        [formData appendPartWithFileData:videoData name:@"files" fileName:fileName mimeType:@"video/mp4"];
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSDictionary *allHeaders = response.allHeaderFields;
        
        
        NSArray * allCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
        for (NSHTTPCookie * cookies in allCookies) {
            if ([cookies.name isEqualToString:@"token"]) {
                NSString * token = [NSString stringWithFormat:@"bearer %@",cookies.value];
                SaveToken(token);
                
                NSString *authorization = [NSString stringWithFormat:@"\"%@\"",token];
                SaveAuthorization(authorization);
            }
            
            
            if ([cookies.name isEqualToString:@"JSESSIONID"]) {
                NSString *jsh_session_id = [NSString stringWithFormat:@"\"%@\"",cookies.value];
                
                if (![NSString isBlankString:jsh_session_id]) {
                    SaveJSHSessionId(jsh_session_id);
                }
            }
            
            
            if ([cookies.name isEqualToString:@"jsh-remember-me"]) {
                NSString *jsh_remember_me = [NSString stringWithFormat:@"\"%@\"",cookies.value];
                
                if (![NSString isBlankString:jsh_remember_me]) {
                    SaveRememberMe(jsh_remember_me);
                }
            }
        }
        
        NSString *access_token = allHeaders[@"access_token"];
        if (isNonemptyString(access_token)) {
            NSString *token = [NSString stringWithFormat:@"bearer %@",access_token];
            
            SaveToken(token);
        }
        
        if(isNonemptyString(responseObject[@"errorMsg"])){
            [MBProgressHUD hideHUDForView:JSHmainWindow];
            [MBProgressHUD showError:responseObject[@"errorMsg"] toView:JSHmainWindow];
            
            if (success) {
                success(nil);
                
            }
        } else {
            if (success) {
                success(responseObject);
                
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            
            failure(error);
        }
    }];
}

- (NSString *)random_32_String {
    
    NSString *string = [[NSString alloc] init];
    for (int i = 0; i < 32; i++) {
        int number = arc4random() % 36;
        if (number < 10) {
            int figure = arc4random() % 10;
            NSString *tempString = [NSString stringWithFormat:@"%d", figure];
            string = [string stringByAppendingString:tempString];
        }else {
            int figure = (arc4random() % 26) + 97;
            char character = figure;
            NSString *tempString = [NSString stringWithFormat:@"%c", character];
            string = [string stringByAppendingString:tempString];
        }
    }
    return string;
}

//上传图片以及声音
-(void)postVoiceWithUrl:(NSString *)url parameters:(id)parameters voice:(NSData *)voiceData fileName:(NSString *)fileName imageArray:(NSArray *)imageArray success:(Success)success failure:(Failure)failure
{
        NSLog(@"接口URL:%@",url);
        [self.afnManager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            if (voiceData) {
                //上传声音
                [formData appendPartWithFileData:voiceData name:fileName  fileName:@"video.mp3" mimeType:@"multipart/form-data"];
            }
                        
            for (UIImage *image in imageArray) {
                
                //将图片摆正
                UIImage *newImage = [UIImage fixOrientation:image];
                
                //压缩上传图片
                NSData *imageData = UIImageJPEGRepresentation(newImage, 0.5);
                
                //随机生成32位字符串
                NSString *string = [[NSString alloc]init];
                for (int i = 0; i < 32; i++) {
                    int number = arc4random() % 36;
                    if (number < 10) {
                        int figure = arc4random() % 10;
                        NSString *tempString = [NSString stringWithFormat:@"%d", figure];
                        string = [string stringByAppendingString:tempString];
                    }else {
                        int figure = (arc4random() % 26) + 97;
                        char character = figure;
                        NSString *tempString = [NSString stringWithFormat:@"%c", character];
                        string = [string stringByAppendingString:tempString];
                    }
                }
                
                
                // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
                NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", string];
                
                /*
                 *该方法的参e数
                 1. appendPartWithFileData：要上传的照片[二进制流]
                 2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
                 3. fileName：要保存在服务器上的文件名
                 4. mimeType：上传的文件的类型
    //             */
            [formData appendPartWithFileData:imageData name:@"pictureList" fileName:fileName mimeType:@"image/jpeg"]; //
            
                
            }
            
            
           
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
            NSDictionary *allHeaders = response.allHeaderFields;
            
            
            NSArray * allCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
            for (NSHTTPCookie * cookies in allCookies) {
                if ([cookies.name isEqualToString:@"token"]) {
                    NSString * token = [NSString stringWithFormat:@"bearer %@",cookies.value];
                    SaveToken(token);
                    
                    NSString *authorization = [NSString stringWithFormat:@"\"%@\"",token];
                    SaveAuthorization(authorization);
                }
                
                
                if ([cookies.name isEqualToString:@"JSESSIONID"]) {
                    NSString *jsh_session_id = [NSString stringWithFormat:@"\"%@\"",cookies.value];
                    
                    if (![NSString isBlankString:jsh_session_id]) {
                        SaveJSHSessionId(jsh_session_id);
                    }
                }
                
                
                if ([cookies.name isEqualToString:@"jsh-remember-me"]) {
                    NSString *jsh_remember_me = [NSString stringWithFormat:@"\"%@\"",cookies.value];
                    
                    if (![NSString isBlankString:jsh_remember_me]) {
                        SaveRememberMe(jsh_remember_me);
                    }
                }
                
                
            }
            
            NSString *access_token = allHeaders[@"access_token"];
            if (isNonemptyString(access_token)) {
                NSString *token = [NSString stringWithFormat:@"bearer %@",access_token];
                
                SaveToken(token);
            }
            
            
            if(isNonemptyString(responseObject[@"errorMsg"])){
                [MBProgressHUD hideHUDForView:JSHmainWindow];
                [MBProgressHUD showError:responseObject[@"errorMsg"] toView:JSHmainWindow];
                
                if (success) {
                    success(nil);
                    
                }
            } else {
                if (success) {
                    success(responseObject);
                    
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (error) {
                
                failure(error);
            }
        }];
}

@end
