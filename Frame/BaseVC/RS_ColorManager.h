//
//  ColorManager.h
//  KuaiJieTongETC
//
//  Created by 王青森 on 2019/1/6.
//  Copyright © 2018年 xianjinjiaotong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RS_ColorManager : NSObject

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;
+ (UIColor *)colorWithHexString:(NSString *)stringToConvert alpha:(float)alpha;

@end
