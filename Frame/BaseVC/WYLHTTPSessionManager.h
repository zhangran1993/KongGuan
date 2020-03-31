//
//  WYLHTTPSessionManager.h
//
//  Created by 王云龙 on 15/12/6.
//  Copyright © 2015年 xiaomage. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface WYLHTTPSessionManager : AFHTTPSessionManager
/// 追加cookie
- (void)addCookie;

- (NSString *)getCookieValue;
@end
