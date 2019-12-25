//
//  HSIEmptyDataSetView.m
//  HiSmartInternational
//
//  Created by centling on 2018/6/28.
//  Copyright © 2018年 Hisense. All rights reserved.
//

#import "HSIEmptyDataSetView.h"
#import "UIView+LX_Frame.h"
@implementation HSIEmptyDataSetView

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.size = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    self.button.backgroundColor = [UIColor whiteColor];
    self.button.titleLabel.textColor = navigationColor;
    self.button.layer.borderWidth = 1;
    self.button.layer.borderColor = navigationColor.CGColor;
    self.button.layer.cornerRadius = self.button.lx_height/2;
}

@end
