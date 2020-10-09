//
//  KG_SpecialNoneDataView.m
//  Frame
//
//  Created by zhangran on 2020/9/18.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_SpecialNoneDataView.h"

@interface KG_SpecialNoneDataView () {
    
    
}

@property (nonatomic, strong) UILabel *titleLabel;



@end


@implementation KG_SpecialNoneDataView

- (instancetype)init
{
    self = [super init];
    if (self) {
       
        [self initData];
        [self setupDataSubviews];
    }
    return self;
}
//初始化数据
- (void)initData {
    
   
}

//创建视图
-(void)setupDataSubviews
{
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.mas_width);
        make.height.equalTo(self.mas_height);
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    UIImageView *bgimage= [[UIImageView alloc]init];
    [bgView addSubview:bgimage];
    bgimage.image = [UIImage imageNamed:@"prompt_alertIcon"];
    [bgimage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(bgView.mas_width);
        make.height.equalTo(bgView.mas_height);
        make.centerX.equalTo(bgView.mas_centerX);
        make.centerY.equalTo(bgView.mas_centerY);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.textColor = [UIColor colorWithHexString:@""];
    [bgView addSubview:self.titleLabel];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font  =[UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    [self.titleLabel sizeToFit];
    self.titleLabel.text = @"未自动获取到数值";
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(5);
        make.right.equalTo(bgView.mas_right).offset(-5);
        make.top.equalTo(bgView.mas_top).offset(2);
        make.bottom.equalTo(bgView.mas_bottom).offset(-2);
    }];
    
}

@end
