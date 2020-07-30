//
//  KG_UpdateSegmentControl.m
//  Frame
//
//  Created by zhangran on 2020/7/28.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_UpdateSegmentControl.h"

@implementation KG_UpdateSegmentControl

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
/**< 解决UISegmentedControl  文字显示q不全的问题 */
- (void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView *subView in self.subviews) {
        for (UIView *subSubview in subView.subviews) {
            if ([subSubview isKindOfClass:[UILabel class]]) {
                UILabel *label = (UILabel *)subSubview;
                label.adjustsFontSizeToFitWidth = YES;
            }
        }
    }
}
@end
