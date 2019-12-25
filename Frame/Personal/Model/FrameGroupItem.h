//
//  FrameGroupItem.h
//  
//
//  Created by Hibaysoft on 17/7/4.
//  Copyright (c) 2018年 Hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FrameGroupItem : NSObject

/** 头部标题 */
@property (strong, nonatomic) NSString * headerTitle;
/** 尾部标题 */
@property (strong, nonatomic) NSString * footerTitle;

/** 组中的行数组 */
@property (strong, nonatomic) NSArray * items;


@end
