//
//  NSArray+SMSafeMethod.m
//  SMZDM
//
//  Created by 李春慧 on 15/5/14.
//  Copyright (c) 2015年 李春慧. All rights reserved.
//

#import "NSArray+SMSafeMethod.h"
#import "NSObject+SafeMethod.h"

@implementation NSArray (SMSafeMethod)

/**
 *  取数组中的元素预防越界
 *
 *  @param index 下表
 *
 *  @return 数组中相应下表的元素
 */
- (id)sm_objectAtSafeIndex:(NSUInteger)index
{
    if (arrayHasData(self)) {
        if (index >= self.count) {
            NSLog(@"数组越界%lu-%lu",(unsigned long)index,(unsigned long)self.count);
            return nil;
        }
    } else {
        NSLog(@"数组为空");
        return nil;
    }
    
    return [self objectAtIndex:index];
}

@end
