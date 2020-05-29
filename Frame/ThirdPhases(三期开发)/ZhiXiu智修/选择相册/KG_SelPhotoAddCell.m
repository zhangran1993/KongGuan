//
//  KG_SelPhotoCollectionViewCell.m
//  Frame
//
//  Created by zhangran on 2020/5/25.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_SelPhotoAddCell.h"

@interface KG_SelPhotoAddCell (){
    
}

@end

@implementation KG_SelPhotoAddCell



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
    [self.addBtn setImage:[UIImage imageNamed:@"add_photo"] forState:UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(closeBtnMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.width.height.equalTo(@70);
        make.top.equalTo(self.mas_top);
    }];
    
    
    
}
//关闭方法
- (void)closeBtnMethod:(UIButton *)button {
    if (self.addMethod) {
        self.addMethod();
    }
    
}
- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;

}
@end
