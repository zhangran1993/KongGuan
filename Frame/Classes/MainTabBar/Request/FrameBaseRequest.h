//
//  FrameBaseRequest.h
//  TenMinDemo
//
//  Created by Hibaysoft on 17/7/4.
//  Copyright (c) 2018年 Hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSTextView.h"

@interface FrameBaseRequest : NSObject
+ (BOOL)isEmptyWithString:(NSString *)string;
+(NSString *)convertToJsonData:(NSMutableArray *)dict;
+ (void)logout;
+ (void)showviewLoadView;
+ (void)addTViewParent:(UIView *)ParentView textView:(FSTextView *)textView text:(NSString*)text placeholder:(NSString *)placeholder maxLength:(int)maxLength;

+ (BOOL)isPureInt:(NSString *)string;
+(NSString *)getDateByTimesp:(double)date dateType:(NSString *)dateType;
+(void)showMessage:(NSString*)message;
/*
 *第二种方法，利用Emoji表情最终会被编码成Unicode，因此，
 *只要知道Emoji表情的Unicode编码的范围，
 *就可以判断用户是否输入了Emoji表情。
 */

+ (BOOL)stringContainsEmoji:(NSString *)string;
+ (void)getWithUrl:(NSString *)url param:(id)param resultClass:(Class)resultClass success:(void (^)(id))success failure:(void (^)(NSError *))failure;


+ (void)getWithUrl:(NSString *)url param:(id)param success:(void (^)(id))success failure:(void (^)(NSURLSessionDataTask *))failure;
+ (void)deleteWithUrl:(NSString *)url param:(id)param success:(void (^)(id))success failure:(void (^)(NSError *))failure;
+ (void)postWithUrl:(NSString *)url param:(id)param success:(void (^)(id))success failure:(void (^)(NSError *))failure;
+ (void)putWithUrl:(NSString *)url param:(id)param success:(void (^)(id))success failure:(void (^)(NSError *))failure;
/**
 *  返回result下item_list 数组模型
 *
 *  @param url          请求地址
 *  @param param        请求参数
 *  @param resultClass  需要转换返回的数据模型
 *  @param success      请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param warn         请求失败后警告提示语（是一个字符串，直接弹出显示即可）
 *  @param failure      请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 *  @param tokenInvalid token过期后的回调（请将token后想做的事情写到这个block中）
 
+ (void)postItemListWithUrl:(NSString *)url param:(id)param
                resultClass:(Class)resultClass
                    success:(void (^)(id result))success
                       warn:(void (^)(NSString *warnMsg))warn
                    failure:(void (^)(NSError *error))failure
               tokenInvalid:(void (^)())tokenInvalid;
 */

/**
 *  返回result下item_list 数组模型（带HUD）
 *
 *  @param url          请求地址
 *  @param param        请求参数
 *  @param resultClass  需要转换返回的数据模型
 *  @param success      请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param warn         请求失败后警告提示语（是一个字符串，直接弹出显示即可）
 *  @param failure      请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 *  @param tokenInvalid token过期后的回调（请将token后想做的事情写到这个block中）
 
+ (void)postItemListHUDWithUrl:(NSString *)url param:(id)param
                   resultClass:(Class)resultClass
                       success:(void (^)(id result))success
                          warn:(void (^)(NSString *warnMsg))warn
                       failure:(void (^)(NSError *error))failure
                  tokenInvalid:(void (^)())tokenInvalid;
 */

/**
 *  返回result 数据模型
 *
 *  @param url          请求地址
 *  @param param        请求参数
 *  @param resultClass  需要转换返回的数据模型
 *  @param success      请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param warn         请求失败后警告提示语（是一个字符串，直接弹出显示即可）
 *  @param failure      请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 *  @param tokenInvalid token过期后的回调（请将token后想做的事情写到这个block中）
 */
- (void)postResultWithUrl:(NSString *)url param:(id)param
              resultClass:(Class)resultClass
                  success:(void (^)(id result))success
                     warn:(void (^)(NSString *warnMsg))warn
                  failure:(void (^)(NSError *error))failure
             tokenInvalid:(void (^)(void))tokenInvalid;

/**
 *  返回result 数据模型（带HUD）
 *
 *  @param url          请求地址
 *  @param param        请求参数
 *  @param resultClass  需要转换返回的数据模型
 *  @param success      请求成功后的回调（请将请求成功后想做的事情写到这个block中）
 *  @param warn         请求失败后警告提示语（是一个字符串，直接弹出显示即可）
 *  @param failure      请求失败后的回调（请将请求失败后想做的事情写到这个block中）
 *  @param tokenInvalid token过期后的回调（请将token后想做的事情写到这个block中）
 
+ (void)postResultHUDWithUrl:(NSString *)url param:(id)param
                 resultClass:(Class)resultClass
                     success:(void (^)(id result))success
                        warn:(void (^)(NSString *warnMsg))warn
                     failure:(void (^)(NSError *error))failure
                tokenInvalid:(void (^)())tokenInvalid;

*/
@end
