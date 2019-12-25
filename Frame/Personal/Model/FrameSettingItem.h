//
//  FrameSettingItem.h
//  
//
//  Created by Hibaysoft on 17/7/4.
//  Copyright (c) 2018年 Hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FrameSettingItem : NSObject

@property (strong, nonatomic) NSString * title;/**< 标题 */

@property (copy, nonatomic) NSString * litpic;/** 图片 */

+ (instancetype)itemWithtitle:(NSString *)title;/**< 设置标题值 类方法 */
+ (instancetype)itemWithimg:(NSString *)img;/**< 设置图片 类方法 */
+ (instancetype)itemWithtitle:(NSString *)title itemWithimg:(NSString *)img;/**< 设置图片 类方法 */

@end
