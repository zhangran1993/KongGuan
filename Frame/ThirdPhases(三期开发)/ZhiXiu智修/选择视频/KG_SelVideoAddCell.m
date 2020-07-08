//
//  KG_SelVideoAddCell.m
//  Frame
//
//  Created by zhangran on 2020/5/25.
//  Copyright © 2020 hibaysoft. All rights reserved.
//
#import "KG_SelVideoAddCell.h"

@interface KG_SelVideoAddCell (){
    
}

@end

@implementation KG_SelVideoAddCell



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
   
    
    
    self.addBtn = [[UIButton alloc]init];
    [self addSubview:self.addBtn];
    [self.addBtn setBackgroundImage:[UIImage imageNamed:@"video_addiamge"] forState:UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(closeBtnMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.width.equalTo(@100);
        make.height.equalTo(@60);
        make.top.equalTo(self.mas_top);
    }];
    
    
    
}
//方法
- (void)closeBtnMethod:(UIButton *)button {
    [UserManager shareUserManager].isDeletePicture = NO;
    if (self.addVideoMethod) {
        self.addVideoMethod();
    }
    
}
- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;

}
@end
