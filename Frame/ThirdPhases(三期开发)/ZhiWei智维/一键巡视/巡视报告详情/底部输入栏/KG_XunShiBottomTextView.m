//
//  KG_XunShiBottomTextView.m
//  Frame
//
//  Created by zhangran on 2020/4/27.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_XunShiBottomTextView.h"

@interface KG_XunShiBottomTextView ()<UITextFieldDelegate>{
    
}

@property (nonatomic,strong) UITextField *textField;

@property (nonatomic,strong) UIButton *addBtn;

@end

@implementation KG_XunShiBottomTextView

-(instancetype)init {
    self = [super init];
    if (self) {
        [self createView];
    }
    return self;
}


- (void)createView {
    self.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    
    self.textField = [[UITextField alloc]init];
    [self addSubview:self.textField];
    self.textField.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.textField.placeholder = @"说说你的想法…";
    self.textField.font = [UIFont systemFontOfSize:14];
    self.textField.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.height.equalTo(@39);
        make.right.equalTo(self.mas_right).offset(-51);
        make.centerY.equalTo(self.mas_centerY);
        
    }];
    
    self.addBtn = [[UIButton alloc]init];
    [self addSubview:self.addBtn];
    [self.addBtn setBackgroundImage:[UIImage imageNamed:@"add_btnIcon"] forState:UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(addMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15.5);
        make.width.height.equalTo(@26);
    }];
   
        
}

- (void)addMethod:(UIButton *)button {
    
}
@end
