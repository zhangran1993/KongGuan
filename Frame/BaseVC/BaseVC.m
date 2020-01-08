
//  BaseVC.m
//  ChongShe
//
//  Created by 马仔哥 on 2018/2/26.
//  Copyright © 2018年 7s_rain. All rights reserved.
//

#import "BaseVC.h"

@interface BaseVC ()

@end

@implementation BaseVC

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationController.navigationBarHidden = YES;

    [self addTitleView];

    self.view.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
}


- (void)setTitle:(NSString *)title
{
    [super setTitle:title];

    self.navTitleLabel.text = title;
    [self.navTitleLabel sizeToFit];
    self.navTitleLabel.top = kDefectHeight;
    self.navTitleLabel.centerX = self.view.width * 0.5;
}


- (void)back
{


    [self.navigationController popViewControllerAnimated:YES];
}

- (CGFloat)getNavHight
{

    return NAVIGATIONBAR_HEIGHT;
}

- (CGFloat)getTabBarHight
{


    if (iPhoneX) {

        return 83.0;
    }
    else {

        return 49.0;
    }
}

- (CGFloat)getBootomHeight
{

    if (iPhoneX) {

        return 34.0;
    }
    else {

        return 0.0;
    }
}

- (void)setUpBackBtn
{
    UIView *backView = [[UIView alloc] init];
    [self.view addSubview:backView];
    backView.sd_layout
        .bottomSpaceToView(self.view, kWScale * 85)
        .rightEqualToView(self.view)
        .widthIs(kWScale * 55)
        .heightIs(kWScale * 35);
    backView.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.7];
    backView.userInteractionEnabled = YES;
    //设置左上角左下角的圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:backView.frame byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(kWScale * 10, kWScale * 10)];

    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];

    maskLayer.frame = backView.frame;

    maskLayer.path = maskPath.CGPath;

    backView.layer.mask = maskLayer;

    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backAction)];
    [tapGes setNumberOfTapsRequired:1];
    [backView addGestureRecognizer:tapGes];


    UIImageView *icon = [[UIImageView alloc] init];
    [backView addSubview:icon];
    icon.sd_layout
        .centerYEqualToView(backView)
        .leftSpaceToView(backView, kWScale * 10)
        .widthIs(kWScale * 12)
        .heightIs(kWScale * 12);
    icon.image = IMAGE(@"doublearrow");

    UILabel *title = [[UILabel alloc] init];
    [backView addSubview:title];
    title.sd_layout
        .centerYEqualToView(backView)
        .leftSpaceToView(icon, kWScale * 5)
        .widthIs(kWScale * 20)
        .heightIs(kWScale * 12);
    title.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    title.font = [UIFont systemFontOfSize:kWScale * 10.0];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"首页";
    [title setSingleLineAutoResizeWithMaxWidth:(kWScale * 50)];
    [title updateLayout];
}

- (void)backAction
{
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
}


//找到导航栏最下面黑线视图
- (UIImageView *)getLineViewInNavigationBar:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }

    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self getLineViewInNavigationBar:subview];
        if (imageView) {

            imageView.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
            return imageView;
        }
    }
    return nil;
}

#pragma mark -getter or setter
- (void)addTitleView
{

    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT)];
    navigationView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navigationView];
    self.navigationView = navigationView;


    [navigationView addSubview:self.navTitleLabel];
    [self.navTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
      make.centerX.equalTo(navigationView.mas_centerX);
      make.bottom.equalTo(navigationView.mas_bottom).offset(-13);
      make.width.lessThanOrEqualTo(@(SCREEN_WIDTH - 120));
    }];

    UIView *line = [[UIView alloc] init];
    line.backgroundColor = LCColor(@"#D7D7D7");
    [navigationView addSubview:line];
    self.line = line;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.bottom.right.equalTo(navigationView);
      make.height.mas_equalTo(@0.5);
    }];

    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [navigationView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
      make.left.mas_equalTo(0);
      make.width.mas_equalTo(@40.5);
      make.centerY.equalTo(self.navTitleLabel.mas_centerY);
    }];
    self.backBtn = backBtn;
}


- (UILabel *)navTitleLabel
{
    if (!_navTitleLabel) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.frame = CGRectMake(50, kDefectHeight, SCREEN_WIDTH - 150, NAVIGATIONBAR_HEIGHT - kDefectHeight);
        titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        titleLabel.textColor = LCColor(@"222222");
        titleLabel.text = @" ";
        _navTitleLabel = titleLabel;
    }
    return _navTitleLabel;
}

- (void)setValue:(id)value forUndefinedKey:(nonnull NSString *)key
{
}

@end
