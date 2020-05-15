//
//  RS_EnableDraggingButton.m
//  ylh-app-primary-ios
//
//  Created by 王青森 on 2019/5/30.
//  Copyright © 2019 巨商汇. All rights reserved.
//

#import "RS_EnableDraggingButton.h"

@interface RS_EnableDraggingButton ()
{
    CGPoint _beginPoint;
    CGFloat _rightMargin;
    CGFloat _leftMargin;
    CGFloat _topMargin;
    CGFloat _bottomMargin;
    CGMutablePathRef _pathRef;
}

@end

@implementation RS_EnableDraggingButton

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self addDraggingGesture];
    }
    return self;
}

- (void)addDraggingGesture {
    
    _rightMargin = SCREEN_WIDTH - 36;
    _leftMargin = 36;
    _bottomMargin = SCREEN_HEIGHT - 36 - (IS_FULL_SCREEN ? 34 : 0);
    _topMargin = NAVIGATIONBAR_HEIGHT + 40;
    
    // 按钮可拖动范围
    _pathRef = CGPathCreateMutable();
    CGPathMoveToPoint(_pathRef, NULL, _leftMargin, _topMargin);
    CGPathAddLineToPoint(_pathRef, NULL, _rightMargin, _topMargin);
    CGPathAddLineToPoint(_pathRef, NULL, _rightMargin, _bottomMargin);
    CGPathAddLineToPoint(_pathRef, NULL, _leftMargin, _bottomMargin);
    CGPathAddLineToPoint(_pathRef, NULL, _leftMargin, _topMargin);
    CGPathCloseSubpath(_pathRef);
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    [self addGestureRecognizer:pan];
}

#pragma mark - 按钮拖动手势
- (void)handlePan:(UIPanGestureRecognizer *)pan {
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        _beginPoint = [pan locationInView:self.superview];
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        CGPoint _nowPoint = [pan locationInView:self.superview];
        float offsetX = _nowPoint.x - _beginPoint.x;
        float offsetY = _nowPoint.y - _beginPoint.y;
        CGPoint centerPoint = CGPointMake(_beginPoint.x + offsetX, _beginPoint.y + offsetY);
        if (CGPathContainsPoint(_pathRef, NULL, centerPoint, NO)) {
            self.center = centerPoint;
        } else {
            if (centerPoint.y > _bottomMargin) {
                if (centerPoint.x < _rightMargin&&centerPoint.x > _leftMargin) {
                    self.center = CGPointMake(_beginPoint.x + offsetX, _bottomMargin);
                }
            } else if (centerPoint.y < _topMargin) {
                if (centerPoint.x < _rightMargin&&centerPoint.x > _leftMargin) {
                    self.center = CGPointMake(_beginPoint.x + offsetX, _topMargin);
                }
            }
            else if (centerPoint.x > _rightMargin) {
                self.center = CGPointMake(_rightMargin, _beginPoint.y + offsetY);
            } else if (centerPoint.x < _leftMargin) {
                self.center = CGPointMake(_leftMargin, _beginPoint.y + offsetY);
            }
        }
    } else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateFailed){
    }
}


@end
