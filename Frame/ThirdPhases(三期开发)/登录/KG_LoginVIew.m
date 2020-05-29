//
//  KG_LoginVIew.m
//  Frame
//
//  Created by zhangran on 2020/5/18.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_LoginVIew.h"

@interface KG_LoginVIew (){
    
}

@property (nonatomic,strong) UILabel *loginLabel;

@property (nonatomic,strong) UILabel *loginDetailLabel;

@property (nonatomic,strong) UIView *stationView;

@property (nonatomic,strong) UIView *runView;
@end

@implementation KG_LoginVIew

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
        [self setupDataSubviews];
        self.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    return self;
}
//初始化数据
- (void)initData {
   
}

//创建视图
-(void)setupDataSubviews
{
    
    self.loginLabel = [[UILabel alloc]init];
    [self addSubview:self.loginLabel];
    self.loginLabel.text = @"登录";
    self.loginLabel.textColor = [UIColor colorWithHexString:@"#142038"];
    self.loginLabel.font = [UIFont boldSystemFontOfSize:20];
    self.loginLabel.textAlignment = NSTextAlignmentCenter;
    [self.loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset((SCREEN_WIDTH -200)/2);
        make.top.equalTo(self.mas_top).offset(NAVIGATIONBAR_HEIGHT -64 +87);
        make.height.equalTo(@28);
        make.width.equalTo(@200);
    }];
    
    self.loginDetailLabel = [[UILabel alloc]init];
    [self addSubview:self.loginDetailLabel];
    self.loginDetailLabel.text = @"请先选择登录版本";
    self.loginDetailLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.loginDetailLabel.font = [UIFont systemFontOfSize:14];
    self.loginDetailLabel.textAlignment = NSTextAlignmentCenter;
    [self.loginDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset((SCREEN_WIDTH -200)/2);
        make.top.equalTo(self.loginLabel.mas_bottom).offset(3);
        make.height.equalTo(@20);
        make.width.equalTo(@200);
    }];
    
    self.stationView = [[UIView alloc]init];
    [self addSubview:self.stationView];
    [self.stationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@307);
        make.height.equalTo(@100);
        make.top.equalTo(self.loginDetailLabel.mas_bottom).offset(60);
        make.centerX.equalTo(self.loginDetailLabel.mas_centerX);
    }];
    UIImageView *stationBgImage = [[UIImageView alloc]init];
    [self.stationView addSubview:stationBgImage];
    stationBgImage.image = [UIImage imageNamed:@"staion_bgImage"];
    [stationBgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stationView.mas_left);
        make.right.equalTo(self.stationView.mas_right);
        make.top.equalTo(self.stationView.mas_top);
        make.bottom.equalTo(self.stationView.mas_bottom);
    }];
    
    UILabel *stationLabel = [[UILabel alloc]init];
    [self.stationView addSubview:stationLabel];
    stationLabel.text = @"单台站";
    stationLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    stationLabel.font = [UIFont boldSystemFontOfSize:20];
    stationLabel.textAlignment = NSTextAlignmentLeft;
    [stationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stationView.mas_left).offset(23);
        make.top.equalTo(self.stationView.mas_top).offset(22);
        make.height.equalTo(@28);
        make.width.equalTo(@100);
    }];
    UILabel *stationDetailLabel = [[UILabel alloc]init];
    [self.stationView addSubview:stationDetailLabel];
    stationDetailLabel.text = @"您可以选择某一个台站进行登录";
    stationDetailLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    stationDetailLabel.font = [UIFont systemFontOfSize:14];
    stationDetailLabel.textAlignment = NSTextAlignmentLeft;
    [stationDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.stationView.mas_left).offset(23);
        make.top.equalTo(stationLabel.mas_bottom).offset(7);
        make.height.equalTo(@20);
        make.width.equalTo(@200);
    }];
    
    UIButton *stationBtn = [[UIButton alloc]init];
    [self.stationView addSubview:stationBtn];
    [stationBtn setImage:[UIImage imageNamed:@"go_stationImage"] forState:UIControlStateNormal];
    [stationBtn addTarget:self action:@selector(stationMethod) forControlEvents:UIControlEventTouchUpInside];
    [stationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.stationView.mas_right).offset(-6);
        make.width.height.equalTo(@58);
        make.centerY.equalTo(self.stationView.mas_centerY);
    }];
    
    
    self.runView = [[UIView alloc]init];
    [self addSubview:self.runView];
    [self.runView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@307);
        make.height.equalTo(@100);
        make.top.equalTo(self.stationView.mas_bottom).offset(36);
        make.centerX.equalTo(self.loginDetailLabel.mas_centerX);
    }];
    UIImageView *runBgImage = [[UIImageView alloc]init];
    [self.runView addSubview:runBgImage];
    runBgImage.image = [UIImage imageNamed:@"run_bgImage"];
    [runBgImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.runView.mas_left);
        make.right.equalTo(self.runView.mas_right);
        make.top.equalTo(self.runView.mas_top);
        make.bottom.equalTo(self.runView.mas_bottom);
    }];
    
    UILabel *runLabel = [[UILabel alloc]init];
    [self.runView addSubview:runLabel];
    runLabel.text = @"运行中心";
    runLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    runLabel.font = [UIFont boldSystemFontOfSize:20];
    runLabel.textAlignment = NSTextAlignmentLeft;
    [runLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.runView.mas_left).offset(23);
        make.top.equalTo(self.runView.mas_top).offset(22);
        make.height.equalTo(@28);
        make.width.equalTo(@100);
    }];
    UILabel *runDetailLabel = [[UILabel alloc]init];
    [self.runView addSubview:runDetailLabel];
    runDetailLabel.text = @"如果您有权限，可以查看所有台站";
    runDetailLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    runDetailLabel.font = [UIFont systemFontOfSize:14];
    runDetailLabel.textAlignment = NSTextAlignmentLeft;
    [runDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.runView.mas_left).offset(23);
        make.top.equalTo(runLabel.mas_bottom).offset(7);
        make.height.equalTo(@20);
        make.width.equalTo(@250);
    }];
    
    UIButton *runBtn = [[UIButton alloc]init];
    [self.runView addSubview:runBtn];
    [runBtn setImage:[UIImage imageNamed:@"go_runcenter"] forState:UIControlStateNormal];
    [runBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.runView.mas_right).offset(-6);
        make.width.height.equalTo(@58);
        make.centerY.equalTo(self.runView.mas_centerY);
    }];
    [runBtn addTarget:self action:@selector(runMethod) forControlEvents:UIControlEventTouchUpInside];
}

- (void)stationMethod {

    if (self.stationClick) {
        self.stationClick();
    }
}

- (void)runMethod {
    if (self.runClick) {
        self.runClick();
    }
}
@end
