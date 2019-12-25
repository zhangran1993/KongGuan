//
//  WSLPhotoZoom.h
//  WSLPictureBrowser
//
//  Created by hibayWill on 2018/6/27.
//  Copyright © 2018年 hibayWill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+GIF.h"

@interface WSLPhotoZoom : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong) UIImageView * imageView;

//默认是屏幕的宽和高
@property (assign, nonatomic) CGFloat imageNormalWidth; // 图片未缩放时宽度
@property (assign, nonatomic) CGFloat imageNormalHeight; // 图片未缩放时高度


//重置回原样
- (void)resetUI;


//缩放方法，共外界调用
- (void)pictureZoomWithScale:(CGFloat)zoomScale;

@end
