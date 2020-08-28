//
//  KG_NewScreenSelTimeCell.m
//  Frame
//
//  Created by zhangran on 2020/8/18.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_NewScreenSelTimeCell.h"

@implementation KG_NewScreenSelTimeCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"开始时间";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.height.equalTo(@60);
        make.width.equalTo(@100);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    self.rightBtn = [[UIButton alloc]init];
    [self addSubview:self.rightBtn];
    [self.rightBtn setTitle:@"" forState:UIControlStateNormal];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-100);
        make.height.equalTo(@60);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.width.equalTo(@100);
    }];
   
    self.rightImage = [[UIImageView alloc]init];
    [self addSubview:self.rightImage];
    self.rightImage.image = [UIImage imageNamed:@"common_right"];
    [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.width.height.equalTo(@18);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];
    
    self.promptLabel = [[UILabel alloc]init];
    self.promptLabel.text = @"请选择";
    self.promptLabel.textColor = [UIColor colorWithHexString:@"#7C7E86"];
    self.promptLabel.font = [UIFont systemFontOfSize:14];
    self.promptLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.promptLabel];
    [self.promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightImage.mas_left);
        make.height.equalTo(@60);
        make.width.equalTo(@100);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
}
@end
