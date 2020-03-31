//
//  UtilsJSH.h
//  ylh-app-primary-ios
//
//  Created by 王文渊 on 2018/8/30.
//  Copyright © 2018年 巨商汇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilsJSH : NSObject
@property (nonatomic, assign, getter=isNetValid) BOOL netValid; //网络状态标记
+ (UtilsJSH *)standarInstance;
/**金额添加逗号*/
+ (NSString *)countNumAndChangeformat:(NSString *)num;
//判断空字符串
+ (NSString *)isBlankString:(id)string;
//时间获取 formatter = yyyy-MM-dd HH:mm:ss
+ (NSString *)getDateStrWithDate:(NSTimeInterval)second andFormatter:(NSString *)formatter;
//对图片尺寸进行压缩--
+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;


/**金额添加逗号 没有小数点*/
+ (NSString *)countNumAndChangeformatNotDot:(NSString *)num;

@end
