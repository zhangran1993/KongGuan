//
//  FMFontManager.h
//
//  Created by huangjian on 2019/9/29.
//  Copyright © 2019 huangjian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
extern NSString *const kLocalTextFont;
extern NSString *const kPreLocalTextFont;//上一次字体


typedef NS_ENUM(NSInteger,FMChooseFont) {
    kFMChooseFont_One = 1, //14
    kFMChooseFont_Two = 2, //16
    kFMChooseFont_Three = 3,//18
    kFMChooseFont_Four = 4, //20
    kFMChooseFont_Five = 5, //22
    kFMChooseFont_Six = 6,//24
    kFMChooseFont_Seven = 7,//26
    kFMChooseFont_Eight = 8,//28
};
@interface FMFontManager : NSObject
//检测默认字体(app启动检测)
+(void)checkDefaultFont;

//切换字体刷新单个界面
+(void)refreshFontWithView:(UIView *)view;

//保存上一次和当前选择的字体
+(void)savePreFont:(FMChooseFont)preFont currentFont:(FMChooseFont)currentFont;

//当前字体
+(FMChooseFont)currentFont;

@end

NS_ASSUME_NONNULL_END
