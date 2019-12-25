//
//  DIYNoDataView.m
//  Frame
//
//  Created by centling on 2018/12/18.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "DIYNoDataView.h"

@implementation DIYNoDataView
- (instancetype) initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}



- (void)setupUI {
    self.backgroundColor = [UIColor whiteColor];
    self.noDataImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 60, WIDTH_SCREEN, 120)];
    self.noDataImage.contentMode = 1;
    [self addSubview:self.noDataImage];
    
    self.tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.noDataImage.frame)+FrameWidth(100), WIDTH_SCREEN, 25)];
    self.tipsLabel.font = FontSize(16);
    self.tipsLabel.textColor = [UIColor grayColor];
    self.tipsLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.tipsLabel];
    
    
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(FrameWidth(220), CGRectGetMaxY(self.tipsLabel.frame)+FrameWidth(80), WIDTH_SCREEN - FrameWidth(440), 30)];
    [self.button addTarget:self action:@selector(reloadClick) forControlEvents:UIControlEventTouchUpInside];
    self.button.backgroundColor = [UIColor whiteColor];
    [self.button setTitleColor:navigationColor forState:UIControlStateNormal];
    self.button.layer.borderWidth = 1;
    self.button.layer.borderColor = navigationColor.CGColor;
    self.button.layer.cornerRadius = 15;
    [self.button setTitle:@"重新加载" forState:UIControlStateNormal];
    self.button.titleLabel.font = FontSize(16);
    self.button.userInteractionEnabled = YES;
    [self addSubview:self.button];
    
}


- (void)reloadClick {
    if ([self.delegate respondsToSelector:@selector(DIYNoDataViewButtonClcik)]) {
        [self.delegate DIYNoDataViewButtonClcik];
    }
}

@end
