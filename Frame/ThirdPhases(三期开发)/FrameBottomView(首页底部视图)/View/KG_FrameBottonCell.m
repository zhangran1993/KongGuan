//
//  KG_FrameBottonCell.m
//  Frame
//
//  Created by zhangran on 2020/3/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_FrameBottonCell.h"

@interface KG_FrameBottonCell (){
    
    
}

@end
@implementation KG_FrameBottonCell



- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self setUI];
        
    }
    
    return self;
}


- (void) setUI
{
    
    //功能
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#626262"];
    [self addSubview:self.titleLabel];
    self.titleLabel.numberOfLines = 1;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(14);
        make.height.equalTo(@20);
        make.width.equalTo(@30);
        make.centerY.equalTo(self.mas_centerY);
    }];

   //状态
    self.statusLabel = [[UILabel alloc]init];
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.font = [UIFont systemFontOfSize:14];
    self.statusLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.statusLabel.backgroundColor = [UIColor colorWithHexString:@"#00D0B3"];
    [self addSubview:self.statusLabel];
    self.statusLabel.numberOfLines = 1;
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(7);
        make.height.equalTo(@20);
        make.width.lessThanOrEqualTo(@50);
        make.centerY.equalTo(self.mas_centerY);
    }];

}
@end
