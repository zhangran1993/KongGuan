//
//  PhotoBrowseViewController.h
//  Frame
//
//  Created by centling on 2018/12/20.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhotoBrowseViewController : UIViewController
- (instancetype)initWithImage:(UIImage*)image lastPageFrame:(CGRect)imageFrame;

@property(strong, nonatomic) UIImage* photo;
@property(assign, nonatomic) CGRect photoOrginFrame;
@end

NS_ASSUME_NONNULL_END
