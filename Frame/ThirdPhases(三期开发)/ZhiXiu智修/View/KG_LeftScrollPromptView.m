//
//  KG_LeftScrollPromptView.m
//  Frame
//
//  Created by zhangran on 2020/5/18.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_LeftScrollPromptView.h"

@interface KG_LeftScrollPromptView (){
    
    
}

@property (nonatomic,strong) UIImageView *scrollBgImageView;

@property (nonatomic,strong) UIImageView *leftSliderImageView;

@property (nonatomic,strong) UILabel  *titleLabel;
@end

@implementation KG_LeftScrollPromptView


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
    
    UIButton *bgBtn = [[UIButton alloc]init];
    [self addSubview:bgBtn];
    [bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    [bgBtn addTarget:self action:@selector(hideViewMethod) forControlEvents:UIControlEventTouchUpInside];
    self.scrollBgImageView = [[UIImageView alloc]init];
    [self addSubview:self.scrollBgImageView];
    self.scrollBgImageView.image = [UIImage imageNamed:@"left_sliderBgImage"];
    [self.scrollBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    self.leftSliderImageView = [[UIImageView alloc]init];
    [self addSubview:self.leftSliderImageView];
    self.leftSliderImageView.image = [UIImage imageNamed:@"leftscroll_slider"];
   
    
    self.titleLabel = [[UILabel alloc]init];
    [self addSubview:self.titleLabel];
    self.titleLabel.text = @"左滑可进行操作";
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.textAlignment = NSTextAlignmentRight;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-16);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@25);
        make.width.equalTo(@150);
    }];
    
    [self.leftSliderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@24);
        make.height.equalTo(@16);
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.titleLabel.mas_left).offset(-5);
    }];
}
- (void)hideViewMethod {
    
    self.hidden = YES;
}
@end
