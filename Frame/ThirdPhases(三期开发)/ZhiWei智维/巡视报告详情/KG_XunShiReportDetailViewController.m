//
//  KG_XunShiReportDetailViewController.m
//  Frame
//
//  Created by zhangran on 2020/4/24.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_XunShiReportDetailViewController.h"

@interface KG_XunShiReportDetailViewController ()
/**  标题栏 */
@property (nonatomic, strong)   UILabel      *titleLabel;
@property (nonatomic, strong)   UIView       *navigationView;
@property (strong, nonatomic)   UIImageView  *topImage1;
@end

@implementation KG_XunShiReportDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createNaviTopView];
    
}
- (void)createNaviTopView {
    
    self.topImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 224)];
    [self.view addSubview:self.topImage1];
    self.topImage1.contentMode = UIViewContentModeScaleAspectFill;
    self.topImage1.image  =[UIImage imageNamed:@"zhiwei_topBgImage"];
    
   
   
    /** 导航栏 **/
    self.navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, Height_NavBar)];
    self.navigationView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.navigationView];
    
    /** 添加标题栏 **/
    [self.navigationView addSubview:self.titleLabel];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.navigationView.mas_centerX);
        make.top.equalTo(self.navigationView.mas_top).offset(Height_StatusBar+9);
    }];
    self.titleLabel.text = @"智环";
    
    /** 返回按钮 **/
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@44);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.left.equalTo(self.navigationView.mas_left);
    }];
    
    //按钮设置点击范围扩大.实际显示区域为图片的区域
    UIImageView *leftImage = [[UIImageView alloc] init];
    leftImage.image = IMAGE(@"back_icon");
    [backBtn addSubview:leftImage];
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backBtn.mas_centerX);
        make.centerY.equalTo(backBtn.mas_centerY);
    }];
    
    
}

/** 标题栏 **/
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        UILabel * titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        titleLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}
@end
