//
//  FrameSettingItem.m
//  
//
//  Created by Hibaysoft on 17/7/4.
//  Copyright (c) 2018年 Hibaysoft. All rights reserved.
//

#import "FrameSettingItem.h"

@implementation FrameSettingItem

+ (instancetype)itemWithtitle:(NSString *)title{
    
    FrameSettingItem *item = [[FrameSettingItem alloc]init];
    
    item.title = title;
    
    return item;
}
//- (void)createVC:(UIViewController *)vc Title:(NSString *)title imageName:(NSString *)imageName
+ (instancetype)itemWithimg:(NSString *)img{
    
    FrameSettingItem *item = [[FrameSettingItem alloc]init];
    
    //UIImageView *imageView = [[UIImageView alloc] init];  // 创建imageView对象
    //imageView.frame = CGRectMake(0, 0, 265, 395);  // 设置imageView的尺寸
    //imageView.image = [UIImage imageNamed:img];//加载图片
    item.litpic = img;
    
    return item;
}

+ (instancetype)itemWithtitle:(NSString *)title itemWithimg:(NSString *)img{
    
    FrameSettingItem *item = [[FrameSettingItem alloc]init];
    
    item.title = title;
    item.litpic = img;
    
    return item;
}
@end
