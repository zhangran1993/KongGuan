//
//  UIColor+Extension.h
//  HiSmartInternational
//
//  Created by Seas Cheng on 2018/1/4.
//  Copyright © 2018年 Hisense. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (Extension)

/**
 Creates and returns a color object from hex string.
 **/
+ (nullable UIColor *)colorWithHexString:(NSString *)hexStr;

@end

NS_ASSUME_NONNULL_END
