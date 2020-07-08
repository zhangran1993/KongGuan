//
//  KG_OperationGuideViewController.m
//  Frame
//
//  Created by zhangran on 2020/7/3.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_OperationGuideViewController.h"

@interface KG_OperationGuideViewController ()


@property (nonatomic, strong)  UILabel   *titleLabel;
@property (nonatomic, strong)  UIView    *navigationView;
@property (nonatomic, strong)  UIButton  *rightButton;

@end

@implementation KG_OperationGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
     [self createNaviTopView];
    [self createUI];
}

- (void)createUI {
    UIView *view = [[UIView alloc] init];
    view.frame = CGRectMake(17,Height_NavBar,SCREEN_WIDTH -34,SCREEN_HEIGHT - Height_NavBar);
    view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    // gradient
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,SCREEN_WIDTH -34,45);
    gl.startPoint = CGPointMake(0.5, -0.28);
    gl.endPoint = CGPointMake(0.5, 0.7);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:167/255.0 green:203/255.0 blue:255/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor];
    gl.locations = @[@(0), @(1.0f)];
    [view.layer addSublayer:gl];
    gl.cornerRadius =10;
    gl.masksToBounds = YES;
    view.layer.cornerRadius = 10;
    view.layer.masksToBounds = YES;
    [self.view addSubview:view];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textColor = [UIColor colorWithHexString:@"#030303"];
    [view addSubview:titleLabel];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.right.equalTo(view.mas_right).offset(-15);
        make.top.equalTo(view.mas_top).offset(23);
        make.height.equalTo(@22);
    }];
    titleLabel.text = [NSString stringWithFormat:@"%@%@",safeString(self.dataDic[@"title"]),@"操作指引"];
    
    UILabel *detailLabel = [[UILabel alloc]init];
    detailLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    [view addSubview:detailLabel];
    detailLabel.numberOfLines = 0;
    [detailLabel sizeToFit];
    detailLabel.textAlignment = NSTextAlignmentLeft;
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(view.mas_left).offset(15);
        make.right.equalTo(view.mas_right).offset(-15);
        make.top.equalTo(titleLabel.mas_bottom).offset(28);
        
    }];
    detailLabel.text = [NSString stringWithFormat:@"%@",safeString(self.dataDic[@"operationalGuidelines"])];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillAppear");
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:YES];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
  
    
}
- (void)createNaviTopView {
    
    UIImageView *topImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT +44)];
    [self.view addSubview:topImage1];
    topImage1.backgroundColor  =[UIColor whiteColor];
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT + 44)];
    [self.view addSubview:topImage];
    topImage.backgroundColor  =[UIColor whiteColor];
    topImage.image = [UIImage imageNamed:@"zhiyun_bgImage"];
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
    self.titleLabel.text = @"操作指引";
    
    /** 返回按钮 **/
    UIButton * backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, (Height_NavBar -44)/2, 44, 44)];
    [backBtn addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@44);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
        make.left.equalTo(self.navigationView.mas_left);
    }];
    
    //按钮设置点击范围扩大.实际显示区域为图片的区域
    UIImageView *leftImage = [[UIImageView alloc] init];
    leftImage.image = IMAGE(@"backwhite");
    [backBtn addSubview:leftImage];
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backBtn.mas_centerX);
        make.centerY.equalTo(backBtn.mas_centerY);
    }];
   
    
   
    
  
    
    
}


- (void)backButtonClick:(UIButton *)button {
   
     [self.navigationController popViewControllerAnimated:YES];
    
    
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
