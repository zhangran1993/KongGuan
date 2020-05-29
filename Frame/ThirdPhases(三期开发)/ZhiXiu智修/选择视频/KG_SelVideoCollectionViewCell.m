//
//  KG_SelVideoCollectionViewCell.m
//  Frame
//
//  Created by zhangran on 2020/5/25.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_SelVideoCollectionViewCell.h"

@interface KG_SelVideoCollectionViewCell (){
    
}

@end

@implementation KG_SelVideoCollectionViewCell



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.iconImage = [[UIImageView alloc]init];
    [self addSubview:self.iconImage];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.width.equalTo(@100);
        make.height.equalTo(@60);
        make.left.equalTo(self.mas_left);
    }];
    
    
    self.closeBtn = [[UIButton alloc]init];
    [self addSubview:self.closeBtn];
    [self.closeBtn setImage:[UIImage imageNamed:@"photo_del"] forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeBtnMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.width.height.equalTo(@20);
        make.top.equalTo(self.mas_top);
    }];
    
    
    
}
//关闭方法
- (void)closeBtnMethod:(UIButton *)button {
    if (self.closeVideoMethod) {
        self.closeVideoMethod(button.tag);
    }
    
}
- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;

}
@end
