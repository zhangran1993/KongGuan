//
//  KG_WeiHuCardAlertCell.m
//  Frame
//
//  Created by zhangran on 2020/7/2.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_WeiHuCardAlertCell.h"

@interface KG_WeiHuCardAlertCell (){
    
}


@end

@implementation KG_WeiHuCardAlertCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.button = [[UIButton alloc]init];
    [self.button setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
    [self.button setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    self.button.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.button];
    [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self);
    }];
    self.button.layer.cornerRadius = 6.f;
    self.button.layer.masksToBounds = YES;
    [self.button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
}


- (void)buttonClicked:(UIButton *)button {
    
    if (self.buttonBlockMethod) {
        self.buttonBlockMethod(self.dataDic,self.detailDic,button.tag);
    }
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self.button setTitle:safeString(dataDic[@"systemName"]) forState:UIControlStateNormal];
    if ([safeString(self.selDic[@"systemCode"]) isEqualToString:dataDic[@"systemCode"]]) {
        [self.button setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
        [self.button setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    }else {
        
        [self.button setBackgroundColor:[UIColor colorWithHexString:@"#F8F9FA"]];
        [self.button setTitleColor:[UIColor colorWithHexString:@"#9294A0"] forState:UIControlStateNormal];
    }
}

- (void)setDetailDic:(NSDictionary *)detailDic {
    _detailDic = detailDic;
    [self.button setTitle:safeString(detailDic[@"equipmentName"]) forState:UIControlStateNormal];
    
    if ([safeString(self.selDetailDic[@"equipmentCode"]) isEqualToString:detailDic[@"equipmentCode"]]) {
        [self.button setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
        [self.button setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    }else {

        [self.button setBackgroundColor:[UIColor colorWithHexString:@"#F8F9FA"]];
        [self.button setTitleColor:[UIColor colorWithHexString:@"#9294A0"] forState:UIControlStateNormal];
    }
    
}

- (void)setSelDic:(NSDictionary *)selDic {
    _selDic = selDic;
   
}
- (void)setSelDetailDic:(NSDictionary *)selDetailDic {
    _selDetailDic = selDetailDic;
}
@end
