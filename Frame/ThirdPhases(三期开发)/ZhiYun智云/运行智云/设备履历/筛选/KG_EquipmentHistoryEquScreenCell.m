//
//  KG_NewScreenCell.m
//  Frame
//
//  Created by zhangran on 2020/8/18.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_EquipmentHistoryEquScreenCell.h"


@implementation KG_EquipmentHistoryEquScreenCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    self.btn = [[UIButton alloc]init];
    [self addSubview:self.btn];
   
    [self.btn setTitle:@"" forState:UIControlStateNormal];
    [self.btn setTitleColor:[UIColor colorWithHexString:@"#7C7E86"] forState:UIControlStateNormal];
    [self.btn setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
    self.btn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.btn.layer.cornerRadius =4 ;
    self.btn.layer.masksToBounds = YES;
    self.btn.layer.borderColor = [[UIColor colorWithHexString:@"#F2F2F2"] CGColor];
    self.btn.layer.borderWidth = 1;
    self.btn.titleLabel.numberOfLines = 2;
//    [self.btn addTarget:self action:@selector(confirmMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
}


- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self.btn setTitle:safeString(dataDic[@"name"]) forState:UIControlStateNormal];
}


- (void)setSelStr:(NSString *)selStr {
    _selStr = selStr;
    
    if ([safeString(self.dataDic[@"name"]) isEqualToString:safeString(self.selStr)]) {
        [self.btn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [self.btn setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
    }else {
        [self.btn setTitleColor:[UIColor colorWithHexString:@"#7C7E86"] forState:UIControlStateNormal];
        [self.btn setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
    }
    
}

@end
