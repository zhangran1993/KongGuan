//
//  KG_ChooseSystemHeaderView.m
//  Frame
//
//  Created by zhangran on 2020/6/17.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_CaseLibraryTypeHeaderView.h"

@interface KG_CaseLibraryTypeHeaderView (){
    
}

@end

@implementation KG_CaseLibraryTypeHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self initView];
        
    }
    return self;
}

- (void)initView {
    
    self.iconImage = [[UIImageView alloc]init];
    [self addSubview:self.iconImage];
    self.iconImage.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
    self.iconImage.layer.cornerRadius = 3.f;
    self.iconImage.layer.masksToBounds = YES;
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.width.height.equalTo(@6);
        make.top.equalTo(self.mas_top).offset(20);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"适用型号";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(7);
        make.height.equalTo(@30);
        make.width.equalTo(@150);
        make.centerY.equalTo(self.iconImage.mas_centerY);
    }];
    
}


@end
