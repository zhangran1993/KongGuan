//
//  KG_PowerOnView.m
//  Frame
//
//  Created by zhangran on 2020/4/3.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_AccessCardAlertView.h"
@interface  KG_AccessCardAlertView(){
    
}
@property (nonatomic, strong) UIButton *bgBtn ;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, copy) NSString *passString;
@property (nonatomic, strong) UILabel *goalTitleLabel;

@end
@implementation KG_AccessCardAlertView

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
    self.dataArray = [NSArray arrayWithObjects:@"", nil];
}

//创建视图
-(void)setupDataSubviews
{
    //按钮背景 点击消失
    self.bgBtn = [[UIButton alloc]init];
    [self addSubview:self.bgBtn];
    [self.bgBtn setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    self.bgBtn.alpha = 0.46;
    [self.bgBtn addTarget:self action:@selector(buttonClickMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    UIView *centerView = [[UIView alloc] init];
    centerView.frame = CGRectMake(52.5,209,270,242);
    centerView.backgroundColor = [UIColor whiteColor];
    centerView.layer.cornerRadius = 12;
    centerView.layer.masksToBounds = YES;
    [self addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@270);
        make.height.equalTo(@171);
    }];
    UIButton *centerBtn = [[UIButton alloc]init];
    [centerView addSubview:centerBtn];
    [centerBtn setBackgroundColor:[UIColor clearColor]];
    [centerBtn setTitle:@"" forState:UIControlStateNormal];
    [centerBtn addTarget:self action:@selector(buttonClickMethod:) forControlEvents:UIControlEventTouchUpInside];
    [centerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(centerView.mas_top);
        make.left.equalTo(centerView.mas_left);
        make.right.equalTo(centerView.mas_right);
        make.bottom.equalTo(centerView.mas_bottom);
    }];
    //
    UILabel *titleLabel = [[UILabel alloc]init];
    [centerView addSubview:titleLabel];
    titleLabel.text = @"远程开门操作";
    titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.numberOfLines = 1;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(centerView.mas_centerX);
        make.top.equalTo(centerView.mas_top).offset(18);
        make.width.equalTo(@200);
        make.height.equalTo(@24);
    }];
    
    
    self.goalTitleLabel = [[UILabel alloc]init];
    [centerView addSubview:self.goalTitleLabel];
    self.goalTitleLabel.text = @"目标：电池间";
    self.goalTitleLabel.font = [UIFont systemFontOfSize:14];
    self.goalTitleLabel.textAlignment = NSTextAlignmentLeft;
    self.goalTitleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.goalTitleLabel.numberOfLines = 1;
    [self.goalTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView.mas_left).offset(15);
        make.top.equalTo(titleLabel.mas_bottom).offset(16);
        make.width.equalTo(@200);
        make.height.equalTo(@20);
    }];
    
    UILabel *openLabel = [[UILabel alloc]init];
    [centerView addSubview:openLabel];
    openLabel.text = @"打开：";
    openLabel.font = [UIFont systemFontOfSize:14];
    openLabel.textAlignment = NSTextAlignmentLeft;
    openLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    openLabel.numberOfLines = 1;
    [openLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView.mas_left).offset(15);
        make.top.equalTo(self.goalTitleLabel.mas_bottom).offset(11);
        make.width.equalTo(@52);
        make.height.equalTo(@20);
    }];
    
    
    
    
    UIView *passView = [[UIView alloc]init];
    passView.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:250/255.0 alpha:1.0];
    [centerView addSubview:passView];
    [passView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(openLabel.mas_right).offset(5);
        make.centerY.equalTo(openLabel.mas_centerY);
        make.height.equalTo(@24);
        make.width.equalTo(@114);
    }];
    
    self.textField = [[UITextField alloc]init];
    [passView addSubview:self.textField];
    self.textField.textColor = [UIColor colorWithHexString:@"#24252A"];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(passView);
    }];
    self.textField.font = [UIFont systemFontOfSize:14];
    self.textField.placeholder = @"";
    [self.textField addTarget:self action:@selector(textEdit:) forControlEvents:UIControlEventEditingChanged];
    self.textField.keyboardType = UIKeyboardTypeNumberPad;
    UILabel *remarkPromptLabel = [[UILabel alloc]init];
    [centerView addSubview:remarkPromptLabel];
    remarkPromptLabel.text = @"秒（1-254）";
    remarkPromptLabel.font = [UIFont systemFontOfSize:12];
    remarkPromptLabel.textAlignment = NSTextAlignmentLeft;
    remarkPromptLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    remarkPromptLabel.numberOfLines = 1;
    [remarkPromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passView.mas_right).offset(7);
        make.centerY.equalTo(passView.mas_centerY);
        make.width.equalTo(@100);
        make.height.equalTo(@17);
    }];
    

    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#E6E8ED"];
    [centerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(centerView.mas_bottom).offset(-43);
        make.height.equalTo(@1);
        make.width.equalTo(@270);
        make.left.equalTo(centerView.mas_left);
        make.right.equalTo(centerView.mas_right);
    }];
    
    UIButton *cancelBtn = [[UIButton alloc]init];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [centerView addSubview:cancelBtn];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelMethod:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView.mas_left);
        make.top.equalTo(lineView.mas_bottom);
        make.width.equalTo(@135);
        make.height.equalTo(@43);
    }];
    
    
    UIButton *confirmBtn = [[UIButton alloc]init];
    [centerView addSubview:confirmBtn];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmMethod:) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(centerView.mas_right);
        make.top.equalTo(lineView.mas_bottom);
        make.width.equalTo(@135);
        make.height.equalTo(@43);
    }];
    UIView *botLine = [[UIView alloc]init];
    botLine.backgroundColor = [UIColor colorWithHexString:@"#E6E8ED"];
    [centerView addSubview:botLine];
    [botLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(centerView.mas_centerX);
        make.bottom.equalTo(centerView.mas_bottom);
        make.width.equalTo(@1);
        make.height.equalTo(@43);
    }];
}
//取消
- (void)cancelMethod:(UIButton *)button {
    [self removeFromSuperview];
    [self.textField resignFirstResponder];
  
}
//确定
- (void)confirmMethod:(UIButton *)button {
    if (self.confirmMehtod) {
        self.confirmMehtod(self.passString);
    }
    [self removeFromSuperview];
    [self.textField resignFirstResponder];
    
}
- (void)buttonClickMethod:(UIButton *)button {
    [self removeFromSuperview];
    [self.textField resignFirstResponder];
   
}
-(BOOL)textFieldShouldReturn:(UITextField*)textField {
    
    [textField resignFirstResponder];
    
    return YES;
    
}
- (void)selMethod:(UIButton *)button {
    
}

-(void)dealloc
{
    [super dealloc];
    //第一种方法.这里可以移除该控制器下的所有通知
    //移除当前所有通知
    NSLog(@"移除了所有的通知");
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}
- (void)textEdit:(UITextField *)textField {
    if ([textField isEqual:self.textField]) {
        self.passString = self.textField.text;
    }
}

@end
