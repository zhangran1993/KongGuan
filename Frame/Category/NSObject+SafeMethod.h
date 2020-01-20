//
//  NSObject+SafeMethod.h
//  ylh-app-primary-ios
//
//  Created by zhangran on 2018/8/29.
//  Copyright © 2018年 巨商汇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SafeMethod)

BOOL isSafeObj(id _Nullable anObject);
BOOL isSafeArray(id _Nullable anObject);
BOOL isNonemptyString(id _Nullable anObject);
BOOL isSafeDictionary(id _Nullable anObject);



NSString * _Nonnull safeString(id _Nullable anObject);
BOOL arrayHasData(id _Nullable anObject);
@end
