//
//  KG_SelPhotoCollectionViewCell.m
//  Frame
//
//  Created by zhangran on 2020/5/25.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_SelPhotoCollectionViewCell.h"

@interface KG_SelPhotoCollectionViewCell (){
    
}

@end

@implementation KG_SelPhotoCollectionViewCell



- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    self.iconImage = [[UIButton alloc]init];
    [self addSubview:self.iconImage];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.width.height.equalTo(@70);
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
    [UserManager shareUserManager].isDeletePicture = YES;
    if (self.closeMethod) {
        self.closeMethod(button.tag);
    }
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;

}
@end
