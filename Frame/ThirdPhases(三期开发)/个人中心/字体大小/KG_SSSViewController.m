//
//  ViewController.m
//  ChangeFont
//
//  Created by huangjian on 2019/10/17.
//  Copyright © 2019 huangjian. All rights reserved.
//

#import "KG_SSSViewController.h"
#import "NextViewController.h"
#import <Masonry.h>
#import "UILabel+ChangeFont.h"
#import "FMFontManager.h"
#import "UIFont+Addtion.h"
#import "ChangeFontManager.h"
#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_SSSViewController ()


@property (nonatomic, strong)   UILabel                  *titleLabel;

@property (nonatomic, strong)   UIView                   *navigationView;

@property (nonatomic, strong)   UIButton                 *rightButton;

@end

@implementation KG_SSSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self setUpUI];
    [self createNaviTopView];
}
-(void)btnAction:(UIButton *)btn{
    [self presentViewController:[NextViewController new] animated:YES completion:nil];
}


-(void)setUpUI{
    UILabel *label1 = [[UILabel alloc]init];
    label1.backgroundColor = [UIColor lightGrayColor];
    label1.textColor = [UIColor blueColor];
    label1.font = [UIFont my_font:20];
    label1.text = @"这是第一个label";
    [self.view addSubview:label1];
    
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.textColor = [UIColor purpleColor];
    label2.backgroundColor = [UIColor lightGrayColor];
    label2.font = [UIFont my_font:20];
    label2.text = @"这是第二个label这是第二个label这是第二个label这是第二个label这是第二个label这是第二个label这是第二个label这是第二个label这是第二个label这是第二个label这是第二个label";
    label2.numberOfLines = 0;
    NSMutableAttributedString *mutString = [[NSMutableAttributedString alloc]initWithString:label2.text];
    label2.attributedText = mutString;
    [self.view addSubview:label2];
    
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(100);
        make.left.mas_offset(40);
        make.right.mas_offset(-40);
    }];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(label1.mas_bottom).mas_offset(20);
        make.left.right.mas_equalTo(label1);
    }];
    
    UIButton *goNext = [UIButton buttonWithType:UIButtonTypeCustom];
    goNext.backgroundColor = [UIColor greenColor];
    [goNext setTitle:@"去下一个页面" forState:UIControlStateNormal];
    [goNext setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    goNext.titleLabel.font = [UIFont my_font:20];
    [goNext addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:goNext];
    
    [goNext mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_offset(-60);
        make.size.mas_equalTo(CGSizeMake(200, 50));
    }];
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
    self.titleLabel.text = safeString(@"字体大小");
    
    /** 返回按钮 **/
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, (Height_NavBar -44)/2, 44, 44)];
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

- (UIImage*) createImageWithColor: (UIColor*) color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
