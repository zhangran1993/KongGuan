//
//  UIView+convenience.h
//
//  Created by ZCR on 13-12-11.
//  Copyright (c) 2013年 ZCR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (convenience)

@property (nonatomic) CGPoint frameOrigin;
@property (nonatomic) CGSize frameSize;

@property (nonatomic) CGFloat originX;
@property (nonatomic) CGFloat originY;

// Setting these modifies the origin but not the size.
@property (nonatomic) CGFloat frameRight;
@property (nonatomic) CGFloat frameBottom;

@property (nonatomic) CGFloat frameWidth;
@property (nonatomic) CGFloat frameHeight;

- (BOOL) containsSubView:(UIView *)subView;
- (BOOL) containsSubViewOfClassType:(Class)aClass;

@end
