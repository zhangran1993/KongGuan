//
//  NSArray+SMSafeMethod.h
//  SMZDM
//
//  Created by zhangran on 15/5/14.
//  Copyright (c) 2015年 zhangran. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (SMSafeMethod)

/**
 *  取数组中的元素预防越界
 *
 *  @param index 下表
 *
 *  @return 数组中相应下表的元素
 */
- (id)sm_objectAtSafeIndex:(NSUInteger)index;

@end
