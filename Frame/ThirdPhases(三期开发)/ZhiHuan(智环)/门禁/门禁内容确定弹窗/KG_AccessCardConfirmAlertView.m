//
//  KG_AccessCardConfirmAlertView.m
//  Frame
//
//  Created by zhangran on 2020/6/24.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_AccessCardConfirmAlertView.h"
@interface  KG_AccessCardConfirmAlertView(){
    
}
@property (nonatomic, strong) UIButton *bgBtn ;

@property (nonatomic, strong) UILabel *goalTitleLabel;


@property (nonatomic, copy) NSString *passString;

@end

@implementation KG_AccessCardConfirmAlertView



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
    titleLabel.text = @"远程关门操作";
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
    self.goalTitleLabel.font = [UIFont systemFontOfSize:12];
    self.goalTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.goalTitleLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.goalTitleLabel.numberOfLines = 1;
    [self.goalTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(centerView.mas_centerX);
        make.top.equalTo(titleLabel.mas_bottom).offset(16);
        make.width.equalTo(@200);
        make.height.equalTo(@20);
    }];
    
    UILabel *promptLabel = [[UILabel alloc]init];
    [centerView addSubview:promptLabel];
    promptLabel.text = @"你确定要执行远程关门操作吗？";
    promptLabel.font = [UIFont systemFontOfSize:14];
    promptLabel.textAlignment = NSTextAlignmentCenter;
    promptLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    promptLabel.numberOfLines = 1;
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(centerView.mas_centerX);
        make.top.equalTo(self.goalTitleLabel.mas_bottom).offset(4);
        make.left.equalTo(centerView.mas_left).offset(20);
        make.right.equalTo(centerView.mas_right).offset(-20);
        make.height.equalTo(@24);
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
    
}
//确定
- (void)confirmMethod:(UIButton *)button {
    if (self.confirmMehtod) {
        self.confirmMehtod();
    }
    [self removeFromSuperview];
}
- (void)buttonClickMethod:(UIButton *)button {
     [self removeFromSuperview];
}
- (void)textEdit:(UITextField *)textField {
    self.passString =  textField.text;
}
@end
