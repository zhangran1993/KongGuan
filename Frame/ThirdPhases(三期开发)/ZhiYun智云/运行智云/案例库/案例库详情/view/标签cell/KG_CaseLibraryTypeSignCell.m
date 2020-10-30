//
//  KG_CaseLibraryTypeSignCell.m
//  Frame
//
//  Created by zhangran on 2020/10/22.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_CaseLibraryTypeSignCell.h"

@interface KG_CaseLibraryTypeSignCell () {
    
    
}

@property (nonatomic ,strong) UIButton        *contentBtn;


@end

@implementation KG_CaseLibraryTypeSignCell



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}


- (void)initView {
    
    self.contentBtn = [[UIButton alloc]init];
    
    [self addSubview:self.contentBtn];
    [self.contentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.contentBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    self.contentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.contentBtn setBackgroundColor:[UIColor colorWithHexString:@"#EFF3F8"]];
    self.contentBtn.layer.cornerRadius = 4.f;
    self.contentBtn.layer.masksToBounds = YES;
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self.contentBtn setTitle:safeString(dataDic[@""]) forState:UIControlStateNormal];
}

- (void)setStr:(NSString *)str {
    _str = str;
    [self.contentBtn setTitle:safeString(str) forState:UIControlStateNormal];
}
@end
