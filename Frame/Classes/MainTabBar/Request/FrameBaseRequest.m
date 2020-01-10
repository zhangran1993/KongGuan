//
//  FrameBaseRequest.m
//  Frame
//
//  Created by Hibaysoft on 17/7/4.
//  Copyright (c) 2018年 Hibaysoft. All rights reserved.
//

#import "FrameBaseRequest.h"
#import "FrameHttpRequest.h"
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <JSONKit.h>
#import "NSString+MD5.h"
#import <QuartzCore/QuartzCore.h> 

@implementation FrameBaseRequest


+ (BOOL)isEmptyWithString:(NSString *)string
{
    if (string.length == 0 || [string isEqualToString:@""] || string == nil || string == NULL || [string isEqual:[NSNull null]])
    {
        return YES;
    }
    return NO;
}

+(NSString *)convertToJsonData:(NSMutableArray *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = @"";
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}
+ (void)logout{
    //清除信息
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"newsSet"];
    [userDefaults removeObjectForKey:@"station_code"];
    [userDefaults removeObjectForKey:@"customerId"];
    [userDefaults removeObjectForKey:@"email"];
    [userDefaults removeObjectForKey:@"mobile"];
    [userDefaults removeObjectForKey:@"tel"];
    [userDefaults removeObjectForKey:@"enabled"];
    [userDefaults removeObjectForKey:@"expert"];
    [userDefaults removeObjectForKey:@"hang"];
    [userDefaults removeObjectForKey:@"icon"];
    [userDefaults removeObjectForKey:@"id"];
    [userDefaults removeObjectForKey:@"name"];
    [userDefaults removeObjectForKey:@"orgId"];
    [userDefaults removeObjectForKey:@"orgName"];
    [userDefaults removeObjectForKey:@"role"];
    [userDefaults removeObjectForKey:@"userAccount"];
    [userDefaults removeObjectForKey:@"password"];
    [userDefaults removeObjectForKey:@"warningId"];
    [UserManager shareUserManager].loginSuccess = NO;
}
+ (void)showviewLoadView{
    
    [UIView animateWithDuration:13 animations:^{
        
        //showview.alpha=0;
        
    }completion:^(BOOL finished) {
        
       // [bgView removeFromSuperview];
        
    }];
    
    
}


+ (void)addTViewParent:(UIView *)ParentView textView:(FSTextView *)textView text:(NSString*)text placeholder:(NSString *)placeholder maxLength:(int)maxLength{
    
    
    // FSTextView
    textView = [FSTextView textView];
    textView.font = FontSize(16);
    textView.placeholder = placeholder;
    textView.canPerformAction = NO;
    [ParentView addSubview:textView];
    textView.text = text;
    // 限制输入最大字符数.
    textView.maxLength = maxLength;
    // 添加输入改变Block回调.
    [textView addTextDidChangeHandler:^(FSTextView *textView) {
        NSLog(@"addTextDidChangeHandler");
    }];
    // 添加到达最大限制Block回调.
    [textView addTextLengthDidMaxHandler:^(FSTextView *textView) {
        NSLog(@"addTextLengthDidMaxHandler");
    }];
    // constraint
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [ParentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textView]|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(textView)]];
    [ParentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[textView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textView)]];
    
}


+ (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}


+(NSString *)getDateByTimesp:(double)date dateType:(NSString *)dateType{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:dateType];// HH:mm:ss@"YYYY-MM-dd"
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:date/1000];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    //NSLog(@"confromTimespStr =  %@::%f",confromTimespStr,date);
    return confromTimespStr;
}
+(void)showMessage:(NSString*)message {
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    UIView *showview = [[UIView alloc] initWithFrame:CGRectMake(1,1,1,1)] ;
    showview.backgroundColor= [UIColor blackColor];
    showview.alpha=1.0f;
    
    showview.layer.cornerRadius=5.0f;
    
    showview.layer.masksToBounds=YES;
    
    [window addSubview:showview];
    
    UILabel*label = [[UILabel alloc]init];
    CGSize LabelSize =[message sizeWithAttributes:@{NSFontAttributeName: FontSize(17)}];
    //CGSize LabelSize = [message sizeWithFont:FontSize(17) constrainedToSize:CGSizeMake(290,9000)];
    
    label.frame=CGRectMake(10,10, LabelSize.width, LabelSize.height);
    
    label.text= message;
    
    label.textColor= [UIColor whiteColor];
    
    label.textAlignment=1;
    
    label.backgroundColor= [UIColor clearColor];
    
    label.font= FontSize(15);
    
    [showview addSubview:label];
    
    showview.frame=CGRectMake(([UIScreen mainScreen].bounds.size.width- LabelSize.width-20)/2, [UIScreen mainScreen].bounds.size.height-100, LabelSize.width+20, LabelSize.height+20);
    
    [UIView animateWithDuration:3 animations:^{
        
        showview.alpha=0;
        
    }completion:^(BOOL finished) {
        
        [showview removeFromSuperview];
        
    }];
    
}

+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL containsEmoji = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0,
                                                   [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring,
                                         NSRange substringRange,
                                         NSRange enclosingRange,
                                         BOOL *stop)
     {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs &&
             hs <= 0xdbff)
         {
             if (substring.length > 1)
             {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc &&
                     uc <= 0x1f9c0)
                 {
                     containsEmoji = YES;
                 }
             }
         }
         else if (substring.length > 1)
         {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3 ||
                 ls == 0xfe0f ||
                 ls == 0xd83c)
             {
                 containsEmoji = YES;
             }
         }
         else
         {
             // non surrogate
             if (0x2100 <= hs &&
                 hs <= 0x27ff)
             {
                 containsEmoji = YES;
             }
             else if (0x2B05 <= hs &&
                      hs <= 0x2b07)
             {
                 containsEmoji = YES;
             }
             else if (0x2934 <= hs &&
                      hs <= 0x2935)
             {
                 containsEmoji = YES;
             }
             else if (0x3297 <= hs &&
                      hs <= 0x3299)
             {
                 containsEmoji = YES;
             }
             else if (hs == 0xa9 ||
                      hs == 0xae ||
                      hs == 0x303d ||
                      hs == 0x3030 ||
                      hs == 0x2b55 ||
                      hs == 0x2b1c ||
                      hs == 0x2b1b ||
                      hs == 0x2b50)
             {
                 containsEmoji = YES;
             }
         }
         
         if (containsEmoji)
         {
             *stop = YES;
         }
     }];
    
    return containsEmoji;
}

+ (void)getWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    // 设定动画选项
    animation.duration = 100; // 持续时间
    animation.repeatCount = 0; // 重复次数
    // 设定旋转角度
    animation.fromValue = [NSNumber numberWithFloat:0.0]; // 起始角度
    animation.toValue = [NSNumber numberWithFloat:100 * M_PI]; // 终止角度
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, HEIGHT_SCREEN)];
    
    
    [window addSubview:bgView];
    
    UIView *showview = [[UIView alloc] initWithFrame:CGRectMake((WIDTH_SCREEN-100)/2,(HEIGHT_SCREEN-100)/2,100,100)] ;
    showview.backgroundColor= [UIColor blackColor];
    showview.alpha=0.5f;
    
    showview.layer.cornerRadius=5.0f;
    
    showview.layer.masksToBounds=YES;
    
    [bgView addSubview:showview];
    
    UIImageView *leading = [[UIImageView alloc]initWithFrame:CGRectMake(30,10,40,40)] ;
    leading.image = [UIImage imageNamed:@"leading"];
    [showview addSubview:leading];
    // 添加动画
    [leading.layer addAnimation:animation forKey:@"rotate-layer"];
    
    
    UILabel *leadLabel =  [[UILabel alloc]initWithFrame:CGRectMake(0,50,100,40)] ;
    leadLabel.text = @"加载中…";
    leadLabel.font = FontSize(10);
    leadLabel.textColor = [UIColor whiteColor];
    leadLabel.textAlignment = NSTextAlignmentCenter;
    [showview addSubview:leadLabel];
    
    
    //NSDictionary *params = [param mj_keyValues];
    [FrameHttpRequest get:url params:param success:^(id responseObj) {
        [bgView removeFromSuperview];
        if (success) {
            //字典转模型，使用的是mj_objectWithKeyValues:方法
            //id result = [resultClass mj_objectWithKeyValues:responseObj];
            id result = [resultClass mj_objectArrayWithKeyValuesArray:responseObj];
            
            
            success(result);
        }
    } failure:^(NSError *error) {
        [bgView removeFromSuperview];
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getWithUrl:(NSString *)url param:(id)param success:(void (^)(id))success failure:(void (^)(NSURLSessionDataTask *))failure
{
    [SVProgressHUD dismiss];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];//背景色
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];//遮罩透明SVProgressHUDMaskTypeClear
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];//菊花控件
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];//旋转小图标的 颜色
    [SVProgressHUD showWithStatus:@"加载中…"];
    
    NSDictionary *params = [param mj_keyValues];
    NSString * urla = url;
    for (NSString *key in params) {
        if([urla isEqualToString:url]){
            urla =[NSString stringWithFormat:@"%@?%@=%@",url,key,params[key]];
        }else{
            urla =[NSString stringWithFormat:@"%@&%@=%@",urla,key,params[key]];
        } 
    }
    NSLog(@"url :%@::param::%@",urla,param);
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [FrameHttpRequest newget:url params:params success:^(id responseObj) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isNetwork"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [SVProgressHUD dismiss];
        if (success) {
            success(responseObj);
        }
    } failure:^(NSURLSessionDataTask *error) {
        [SVProgressHUD dismiss];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isNetwork"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (failure) {
            failure(error);
        }
    }];
}


+ (void)getDataWithUrl:(NSString *)url param:(id)param success:(void (^)(id))success failure:(void (^)(NSURLSessionDataTask *))failure
{
   
    NSDictionary *params = [param mj_keyValues];
    NSString * urla = url;
    for (NSString *key in params) {
        if([urla isEqualToString:url]){
            urla =[NSString stringWithFormat:@"%@?%@=%@",url,key,params[key]];
        }else{
            urla =[NSString stringWithFormat:@"%@&%@=%@",urla,key,params[key]];
        }
    }
    NSLog(@"url :%@::param::%@",urla,param);
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [FrameHttpRequest newget:url params:params success:^(id responseObj) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isNetwork"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [SVProgressHUD dismiss];
        if (success) {
            success(responseObj);
        }
    } failure:^(NSURLSessionDataTask *error) {
        [SVProgressHUD dismiss];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isNetwork"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (failure) {
            failure(error);
        }
    }];
}


+ (void)deleteWithUrl:(NSString *)url param:(id)param success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSDictionary *params = [param mj_keyValues];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [FrameHttpRequest delete:url params:params success:^(id responseObj) {
        if (success) {
            success(responseObj);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
+ (void)postWithUrl:(NSString *)url param:(id)param success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    //状态栏菊花
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];//背景色
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];//遮罩透明
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];//菊花控件
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];//旋转小图标的 颜色
    [SVProgressHUD showWithStatus:@"加载中…"];
    
    
    NSDictionary *params = [param mj_keyValues];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    NSLog(@"postWithUrl %@:::%@",url,params);
    FrameHttpRequest *httpRequest = [[FrameHttpRequest alloc]init];
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [httpRequest post:url params:params success:^(id responseObj) {
        [SVProgressHUD dismiss];
        if (success) {
            //NSLog(@"post请求成功，返回数据 : %@",responseObj);
            //NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:responseObj options:kNilOptions error:nil];
            
            success(responseObj);
            
        }
        //状态栏菊花
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (failure) {
            failure(error);
            NSLog(@"postWithUrl请求失败：%@",error);
        }
        //状态栏菊花
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    
}

+ (void)putWithUrl:(NSString *)url param:(id)param success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    //状态栏菊花
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleCustom];
    [SVProgressHUD setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3]];//背景色
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];//遮罩透明
    [SVProgressHUD setDefaultAnimationType:SVProgressHUDAnimationTypeNative];//菊花控件
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];//旋转小图标的 颜色
    [SVProgressHUD showWithStatus:@"加载中…"];
    
    NSDictionary *params = [param mj_keyValues];
    //状态栏菊花
    NSLog(@"putWithUrl %@:::%@",url,params);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [FrameHttpRequest put:url params:params success:^(id responseObj) {
        [SVProgressHUD dismiss];
        if (success) {
            //NSLog(@"putWithUrl请求成功，返回数据 : %@",responseObj);
            success(responseObj);
        }
        //状态栏菊花
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(NSError *error) {
        [SVProgressHUD dismiss];
        if (failure) {
            failure(error);
            NSLog(@"putWithUrl请求失败：%@",error);
        }
        //状态栏菊花
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    
}

/**
 *  返回result下item_list 数组模型
 */
//+ (void)postItemListWithUrl:(NSString *)url param:(id)param
//                resultClass:(Class)resultClass
//                    success:(void (^)(id result))success
//                       warn:(void (^)(NSString *warnMsg))warn
//                    failure:(void (^)(NSError *error))failure
//               tokenInvalid:(void (^)())tokenInvalid
//{
//    
//    [self postBaseWithUrl:url param:param resultClass:resultClass
//                  success:^(id responseObj) {
//                      if (!resultClass || !responseObj[@"result"][@"list"]) {
//                          success(nil);
//                          return;
//                      }
//                      success([resultClass mj_objectArrayWithKeyValuesArray:responseObj[@"result"][@"list"]]);
//                  }
//                     warn:warn
//                  failure:failure
//             tokenInvalid:tokenInvalid];
//}

/**
 *  返回result下item_list 数组模型(带HUD)
 */
//+ (void)postItemListHUDWithUrl:(NSString *)url param:(id)param
//                   resultClass:(Class)resultClass
//                       success:(void (^)(id result))success
//                          warn:(void (^)(NSString *warnMsg))warn
//                       failure:(void (^)(NSError *error))failure
//                  tokenInvalid:(void (^)())tokenInvalid
//{
//    
//    [self postBaseHUDWithUrl:url param:param resultClass:resultClass
//                     success:^(id responseObj) {
//                         if (!resultClass || !responseObj[@"result"][@"list"]) {
//                             success(nil);
//                             return;
//                         }
//                         success([resultClass mj_objectArrayWithKeyValuesArray:responseObj[@"result"][@"list"]]);
//                     }
//                        warn:warn
//                     failure:failure
//                tokenInvalid:tokenInvalid];
//}



/**
 *  返回result 数据模型
 */
- (void)postResultWithUrl:(NSString *)url param:(id)param
              resultClass:(Class)resultClass
                  success:(void (^)(id result))success
                     warn:(void (^)(NSString *warnMsg))warn
                  failure:(void (^)(NSError *error))failure
             tokenInvalid:(void (^)(void))tokenInvalid
{
    
    [self postBaseWithUrl:url param:param resultClass:resultClass
                  success:^(id responseObj) {
                      if (!responseObj) {
                          success(nil);
                          return;
                      }
                      //success([resultClass mj_objectArrayWithKeyValuesArray:responseObj[@"result"]]);
                      success(responseObj);
                  }
                     warn:warn
                  failure:failure
             tokenInvalid:tokenInvalid];
}

/**
 *  返回result 数据模型
 */
//+ (void)postResultHUDWithUrl:(NSString *)url param:(id)param
//                 resultClass:(Class)resultClass
//                     success:(void (^)(id result))success
//                        warn:(void (^)(NSString *warnMsg))warn
//                     failure:(void (^)(NSError *error))failure
//                tokenInvalid:(void (^)())tokenInvalid
//{
//    
//    [self postBaseHUDWithUrl:url param:param resultClass:resultClass
//                     success:^(id responseObj) {
//                         if (!resultClass) {
//                             success(nil);
//                             return;
//                         }
//                         success([resultClass mj_objectWithKeyValues:responseObj[@"result"]]);
//                     }
//                        warn:warn
//                     failure:failure
//                tokenInvalid:tokenInvalid];
//}

- (void)postBaseWithUrl:(NSString *)url param:(id)param
                success:(void (^)(id result))success
                failure:(void (^)(NSError *error))failure
{
    //状态栏菊花
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    FrameHttpRequest *httpRequest = [[FrameHttpRequest alloc]init];
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [httpRequest post:url params:param success:^(id responseObj) {
        if (success) {
            NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:responseObj options:kNilOptions error:nil];
            NSLog(@"postBaseWithUrl请求成功，返回数据 : %@",dictData);
            success(responseObj);
            
        }
        //状态栏菊花
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
            NSLog(@"postBaseWithUrl请求失败：%@",error);
        }
        //状态栏菊花
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

/**
 *  数据模型基类方法
 */
- (void)postBaseWithUrl:(NSString *)url param:(id)param
            resultClass:(Class)resultClass
                success:(void (^)(id result))success
                   warn:(void (^)(NSString *warnMsg))warn
                failure:(void (^)(NSError *error))failure
           tokenInvalid:(void (^)(void))tokenInvalid
{
    //状态栏菊花
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    FrameHttpRequest *httpRequest = [[FrameHttpRequest alloc]init];
    
    url = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [httpRequest post:url params:param success:^(id responseObj) {
        if (success) {
            NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:responseObj options:kNilOptions error:nil];
            NSLog(@"postBaseWithUrl请求成功，返回数据 : %@",dictData);
            success(responseObj);

        }
        //状态栏菊花
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
            NSLog(@"postBaseWithUrl请求失败：%@",error);
        }
        //状态栏菊花
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

/**
 *  数据模型基类(带HUD)
 */
//+ (void)postBaseHUDWithUrl:(NSString *)url param:(id)param
//               resultClass:(Class)resultClass
//                   success:(void (^)(id result))success
//                      warn:(void (^)(NSString *warnMsg))warn
//                   failure:(void (^)(NSError *error))failure
//              tokenInvalid:(void (^)())tokenInvalid
//{
//    [SVProgressHUD showWithStatus:@""];
//    [self postBaseWithUrl:url param:param resultClass:resultClass success:^(id responseObj) {
//        [SVProgressHUD dismiss];    //隐藏loading
//        success(responseObj);
//    } warn:^(NSString *warnMsg) {
//        [SVProgressHUD dismiss];
//        warn(warnMsg);
//    } failure:^(NSError *fail) {
//        [SVProgressHUD dismiss];
//        failure(fail);
//    } tokenInvalid:^{
//        [SVProgressHUD dismiss];
//        tokenInvalid();
//    }];
//}


/**
 *  组合请求参数
 *
 *  @param dict 外部参数字典
 *
 *  @return 返回组合参数
 */
+ (NSMutableDictionary *)requestParams:(NSDictionary *)dict
{
    //
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    return params;
}


@end
