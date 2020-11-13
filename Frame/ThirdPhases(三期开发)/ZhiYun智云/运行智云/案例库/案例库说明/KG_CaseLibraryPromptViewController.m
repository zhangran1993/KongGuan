//
//  KG_HistoryTaskViewController.m
//  Frame
//
//  Created by zhangran on 2020/5/11.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_CaseLibraryPromptViewController.h"

@interface KG_CaseLibraryPromptViewController () {
    
}

@property (nonatomic, strong)   UILabel                 *titleLabel;

@property (nonatomic, strong)   UIView                  *navigationView;


@property (nonatomic, strong)   UIView                  *topLeftView;

@property (nonatomic, strong)   UITextView              *textView;

@property (nonatomic, strong)   UILabel                 *topLeftTitleLabel;


@end

@implementation KG_CaseLibraryPromptViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self createNaviTopView];
    [self createUI];
    
}

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillAppear");
    if (@available(iOS 13.0, *)){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    }else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    [self.navigationController setNavigationBarHidden:YES];
  
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillDisappear");
    [self.navigationController setNavigationBarHidden:YES];
    
}
- (void)createNaviTopView {
    
    UIImageView *topImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT +44)];
    [self.view addSubview:topImage1];
    topImage1.backgroundColor  =[UIColor whiteColor];
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT + 44)];
    [self.view addSubview:topImage];
    topImage.backgroundColor  =[UIColor whiteColor];
    topImage.image = [self createImageWithColor:[UIColor whiteColor]];
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
    self.titleLabel.text = @"案例库说明";
    
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
    leftImage.image = IMAGE(@"back_black");
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
        titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
        _titleLabel = titleLabel;
    }
    return _titleLabel;
}

- (UIImage*)createImageWithColor: (UIColor*) color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createUI {
    
    UIView *bgView = [[UIView alloc]init];
    [self.view addSubview:bgView];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationView.mas_bottom);
        make.height.equalTo(@10);
        make.left.equalTo(self.navigationView.mas_left);
        make.right.equalTo(self.navigationView.mas_right);
    }];
    
    self.topLeftView = [[UIView alloc] init];
    [self.view addSubview:self.topLeftView];
    self.topLeftView.layer.backgroundColor = [UIColor colorWithRed:47/255.0 green:94/255.0 blue:209/255.0 alpha:1.0].CGColor;
    self.topLeftView.layer.cornerRadius = 2;
    
    [self.topLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_bottom).offset(12);
        make.height.equalTo(@14);
        make.left.equalTo(self.view.mas_left).offset(16);
        make.width.equalTo(@4);
    }];
    
    self.topLeftTitleLabel = [[UILabel alloc]init];
    [self.view addSubview:self.topLeftTitleLabel];
    self.topLeftTitleLabel.text = @"故障案例库说明";
    self.topLeftTitleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.topLeftTitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [self.topLeftTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topLeftView.mas_right).offset(6);
        make.centerY.equalTo(self.topLeftView.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-20);
        
    }];
    
    self.textView = [[UITextView alloc]init];
    self.textView.userInteractionEnabled = NO;
    self.textView.text = @"故障案例库说明详情";
    self.textView.textColor = [UIColor colorWithHexString:@"#626470"];
    self.textView.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(26);
        make.top.equalTo(self.topLeftTitleLabel.mas_bottom).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.bottom.equalTo(self.view.mas_bottom).offset(-20);
    }];
    
    
    
    
    
    
    
    
    
    
    
}

@end
