//
//  CommonBaseViewController.m
//  ylh-app-change
//
//  Created by 巨商汇 on 2019/6/12.
//  Copyright © 2019 巨商汇. All rights reserved.
//

#import "CommonBaseViewController.h"

@interface CommonBaseViewController ()


@end

@implementation CommonBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /** 移除父控制器的导航条,自定义导航条 **/
    [self.navigationView removeFromSuperview];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    [self addTitleView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}


- (void) addTitleView {
    
    /** 导航栏 **/
    UIView * navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_SCREEN, Height_NavBar)];
    navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navigationView];
    self.navigationView = navigationView;
    
    /** 添加标题栏 **/
    [navigationView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(navigationView.mas_centerX);
        make.top.equalTo(navigationView.mas_top).offset(Height_StatusBar+9);
    }];
    
    /** 底部分割线 **/
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = [UIColor colorWithHexString:@"#D7D7D7"];
    [navigationView addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(navigationView);
        make.height.mas_equalTo(@0.5);
    }];
    
    /** 返回按钮 **/
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@44);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.left.equalTo(navigationView.mas_left);
    }];
    
    //按钮设置点击范围扩大.实际显示区域为图片的区域
    UIImageView *leftImage = [[UIImageView alloc] init];
    leftImage.image = IMAGE(@"fanhui");
    [backBtn addSubview:leftImage];
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backBtn.mas_centerX);
        make.centerY.equalTo(backBtn.mas_centerY);
    }];
    
    self.backBtn = backBtn;
}




/** 标题栏 **/
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel * titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        titleLabel.textColor = [UIColor colorWithHexString:@"#222222"];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}


/** 返回按钮点击事件 **/
-(void)backButtonClick{
    [self.navigationController popViewControllerAnimated:YES];
}

/** 设置导航栏标题 **/
-(void)setNavigationTitle:(NSString *)navigationTitle{
    _navigationTitle = navigationTitle;
    self.titleLabel.text = navigationTitle;
}

/** 设置导航栏标题字体大小 **/
-(void)setTitleFont:(CGFloat)titleFont{
    _titleFont = titleFont;
    self.titleLabel.font = Font(titleFont);
}

/** 设置标题栏字体颜色 **/
-(void)setTitleColor:(NSString *)titleColor{
    _titleColor = titleColor;
    self.titleLabel.textColor = [UIColor colorWithHexString:titleColor];
}

/** 是否显示返回按钮 **/
-(void)setIsHiddenLeftBtn:(BOOL)isHiddenLeftBtn{
    self.backBtn.hidden = isHiddenLeftBtn;
}

/** 是否显示底部分割线 **/
-(void)setIsHiddenBottomLine:(BOOL)isHiddenBottomLine{
    self.line.hidden = isHiddenBottomLine;
}

@end
