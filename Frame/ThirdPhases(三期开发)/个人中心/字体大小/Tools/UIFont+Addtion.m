//
//  UIFont+Addtion.m
//  ChangeFont
//
//  Created by huangjian on 2019/10/17.
//  Copyright © 2019 huangjian. All rights reserved.
//

#import "UIFont+Addtion.h"

@implementation UIFont (Addtion)
+(UIFont *)my_font:(CGFloat)fontSize{
    fontSize = [self resetFont:fontSize];
    return [UIFont systemFontOfSize:fontSize];
}

+(UIFont *)my_Pingfont:(CGFloat)fontSize{
    fontSize = [self resetFont:fontSize];
    return [UIFont fontWithName:@"PingFang SC" size:fontSize];
}

+(UIFont *)my_Newfont:(CGFloat)fontSize{
    fontSize = [self alwaysFont:fontSize];
    return [UIFont systemFontOfSize:fontSize];
}
//MARK: - 根据本地存储字体获取新的字体
+(NSInteger)resetFont:(CGFloat)fontSize{
    NSString *localFont = [[NSUserDefaults standardUserDefaults]objectForKey:@"kLocalTextFont"];
    NSInteger font = fontSize;
    if (localFont) {
        font = font + [localFont integerValue] - 2;
    }
    return font;
}

+(NSInteger)alwaysFont:(CGFloat)fontSize{
  
    NSInteger font = fontSize;
   
    return font;
}


@end
