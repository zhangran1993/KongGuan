//
//  KG_PowerOnView.m
//  Frame
//
//  Created by zhangran on 2020/4/3.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_PowerOnView.h"
@interface  KG_PowerOnView(){
    
}
@property (nonatomic, strong) UIButton *bgBtn ;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextView *textView;
@end
@implementation KG_PowerOnView

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
        make.height.equalTo(@242);
    }];
    
//
    UILabel *titleLabel = [[UILabel alloc]init];
    [centerView addSubview:titleLabel];
    titleLabel.text = @"开机操作";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.numberOfLines = 1;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(centerView.mas_centerX);
        make.top.equalTo(centerView.mas_top).offset(18);
        make.width.equalTo(@200);
        make.height.equalTo(@24);
    }];
    
    
    UILabel *passPromptLabel = [[UILabel alloc]init];
    [centerView addSubview:passPromptLabel];
    passPromptLabel.text = @"密码（必填）";
    passPromptLabel.font = [UIFont systemFontOfSize:12];
    passPromptLabel.textAlignment = NSTextAlignmentLeft;
    passPromptLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    passPromptLabel.numberOfLines = 1;
    [passPromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView.mas_left).offset(15);
        make.top.equalTo(centerView.mas_top).offset(60);
        make.width.equalTo(@100);
        make.height.equalTo(@17);
    }];
    
    UIView *passView = [[UIView alloc]init];
    passView.backgroundColor = [UIColor colorWithRed:248/255.0 green:249/255.0 blue:250/255.0 alpha:1.0];
    [centerView addSubview:passView];
    [passView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView.mas_left).offset(16);
        make.top.equalTo(passPromptLabel.mas_bottom).offset(5);
        make.height.equalTo(@24);
        make.right.equalTo(centerView.mas_right).offset(-19);
    }];
    
    self.textField = [[UITextField alloc]init];
    [passView addSubview:self.textField];
    self.textField.textColor = [UIColor colorWithHexString:@"#24252A"];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.left.equalTo(passView);
    }];
    
    UILabel *remarkPromptLabel = [[UILabel alloc]init];
    [centerView addSubview:remarkPromptLabel];
    remarkPromptLabel.text = @"备注（选填）";
    remarkPromptLabel.font = [UIFont systemFontOfSize:12];
    remarkPromptLabel.textAlignment = NSTextAlignmentLeft;
    remarkPromptLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    remarkPromptLabel.numberOfLines = 1;
    [remarkPromptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView.mas_left).offset(15);
        make.top.equalTo(passView.mas_bottom).offset(9);
        make.width.equalTo(@100);
        make.height.equalTo(@17);
    }];
    
    UIView *remarkView = [[UIView alloc]init];
    [centerView addSubview:remarkView];
    remarkView.backgroundColor = [UIColor colorWithHexString:@"#F8F9FA"];
    
    [remarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView.mas_left).offset(16);
        make.right.equalTo(centerView.mas_right).offset(-19);
       
        make.height.equalTo(@50);
        make.top.equalTo(remarkPromptLabel.mas_bottom).offset(4);
    }];
    self.textView = [[UITextView alloc]init];
    [remarkView addSubview:self.textView];
    self.textView.textColor = [UIColor colorWithHexString:@"#24252A"];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.width.equalTo(remarkView);
    }];
    self.textView.backgroundColor =  [UIColor colorWithRed:248/255.0 green:249/255.0 blue:250/255.0 alpha:1.0];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#E6E8ED"];
    [centerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(remarkView.mas_bottom).offset(12);
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
    self.hidden = YES;
    [self.textField resignFirstResponder];
}
//确定
- (void)confirmMethod:(UIButton *)button {
    
}
- (void)buttonClickMethod:(UIButton *)button {
    self.hidden = YES;
    [self.textField resignFirstResponder];
    [self.textView resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField*)textField {
    
    [textField resignFirstResponder];
    
    return YES;
    
}
@end
