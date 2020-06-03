//
//  KG_JiaoJieBanAlertView.m
//  Frame
//
//  Created by zhangran on 2020/5/29.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_JiaoJieBanAlertView.h"
@interface  KG_JiaoJieBanAlertView(){
    
}
@property (nonatomic, strong) UIButton *bgBtn ;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextView *textView;
@end
@implementation KG_JiaoJieBanAlertView

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
        make.height.equalTo(@148);
    }];
    
//
    UILabel *titleLabel = [[UILabel alloc]init];
    [centerView addSubview:titleLabel];
    titleLabel.text = @"选择交接班岗位";
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
    
    UIView *zhibanView = [[UIView alloc]init];
    [centerView addSubview:zhibanView];
    zhibanView.backgroundColor = [UIColor colorWithHexString:@"#F8F9FA"];
    zhibanView.layer.borderColor = [[UIColor colorWithHexString:@"#E6E8ED"] CGColor];
    zhibanView.layer.borderWidth = 0.5;
    [zhibanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView.mas_left).offset(16);
        make.right.equalTo(centerView.mas_right).offset(-16);
        make.top.equalTo(titleLabel.mas_bottom).offset(22);
        make.height.equalTo(@24);
    }];
    UIImageView *zhibanLeftIcon = [[UIImageView alloc]init];
    [zhibanView addSubview:zhibanLeftIcon];
    zhibanLeftIcon.image = [UIImage imageNamed:@"jiaojieban_leftIcon"];
    [zhibanLeftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zhibanView.mas_left).offset(6);
        make.width.height.equalTo(@12);
        make.centerY.equalTo(zhibanView.mas_centerY);
    }];
    UILabel *zhibanLabel = [[UILabel alloc]init];
    [zhibanView addSubview:zhibanLabel];
    zhibanLabel.text = @"值班岗位";
    zhibanLabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
    zhibanLabel.font = [UIFont systemFontOfSize:12];
    [zhibanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zhibanLeftIcon.mas_right).offset(4);
        make.height.equalTo(@17);
        make.width.equalTo(@100);
        make.centerY.equalTo(zhibanView.mas_centerY);
    }];
    UIImageView *zhibanRightImage = [[UIImageView alloc]init];
    [zhibanView addSubview:zhibanRightImage];
    zhibanRightImage.image = [UIImage imageNamed:@"jiaojieban_rightIcon"];
    [zhibanRightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(zhibanView.mas_right).offset(-2);
        make.width.height.equalTo(@12);
        make.centerY.equalTo(zhibanView.mas_centerY);
    }];
    
    UIButton *zhibanBtn = [[UIButton alloc]init];
    [zhibanView addSubview:zhibanBtn];
    [zhibanBtn setTitle:@"黄城导航台保障岗" forState:UIControlStateNormal];
    [zhibanBtn setTitleColor:[UIColor colorWithHexString:@"#24252A"] forState:UIControlStateNormal];
    zhibanBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [zhibanBtn sizeToFit];
    [zhibanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    
    
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#E6E8ED"];
    [centerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(zhibanView.mas_bottom).offset(25);
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
