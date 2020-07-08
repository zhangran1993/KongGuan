//
//  KG_ChooseSystemCell.m
//  Frame
//
//  Created by zhangran on 2020/6/17.
//  Copyright © 2020 hibaysoft. All rights reserved.
//
#import "KG_ChooseSystemCell.h"

@interface KG_ChooseSystemCell (){
    
}

@property (nonatomic, strong) UIButton *button;

@end

@implementation KG_ChooseSystemCell



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.button = [[UIButton alloc]init];
    self.button.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    [self.button setTitleColor:[UIColor colorWithHexString:@"#9294A0"] forState:UIControlStateNormal];
    [self.button setBackgroundColor:[UIColor colorWithHexString:@"#F8F9FA"]];
    self.button.layer.cornerRadius = 4;
    self.button.layer.masksToBounds = YES;
    [self.button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@17);
        make.width.equalTo(self.mas_width);
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
    }];
 
}

- (void)buttonClicked:(UIButton *)button {
    if (self.didsel) {
        self.didsel(self.dataDic);
    }
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
  
}
@end
