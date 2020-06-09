//
//  PersonalFollowUsController.m
//  Frame
//
//  Created by hibayWill on 2018/3/17.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "PersonalFollowUsController.h"
#import "PersonalEditPwdController.h"
#import "FrameBaseRequest.h"

@interface PersonalFollowUsController (){
}

@property (nonatomic, strong)  UILabel   *titleLabel;
@property (nonatomic, strong)  UIView    *navigationView;
@property (nonatomic, strong)  UIButton  *rightButton;

@end

@implementation PersonalFollowUsController

//static NSString * const reuseIdentifier = @"Cell";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关注我们";

    [self.navigationController setNavigationBarHidden:YES];
    [self createNaviTopView];
    [self backBtn];
    [self loadBgView];
    
}
-(void)loadBgView{
    //背景色
    self.view.backgroundColor =  [UIColor  colorWithPatternImage:[UIImage imageNamed:@"personal_gray_bg"]] ;
    //logo和版本
    UIImageView *logoImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    
    logoImg.frame = CGRectMake( FrameWidth(270),  FrameWidth(55) + Height_NavBar,  FrameWidth(100),  FrameWidth(100));
    
    UILabel *vsersionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, FrameWidth(170) + Height_NavBar , WIDTH_SCREEN,  FrameWidth(20))];
    vsersionLabel.textAlignment = NSTextAlignmentCenter;
    vsersionLabel.textColor = [UIColor lightGrayColor];
    vsersionLabel.font = FontSize(14);
    vsersionLabel.text = AppVersion;
    [self.view addSubview:vsersionLabel];
    
    [self.view addSubview:logoImg];
    //微信关注
    UIImageView *QRImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personal_wx"]];
    
    QRImg.frame = CGRectMake(FrameWidth(213), FrameWidth(210)+ Height_NavBar, FrameWidth(213), FrameWidth(213));
    
    UILabel *WXLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(20),FrameWidth(440) ,FrameWidth(600), FrameWidth(20))];
    WXLabel.textAlignment = NSTextAlignmentCenter;
    WXLabel.textColor = [UIColor lightGrayColor];
    WXLabel.font = FontSize(14);
    WXLabel.text = @"青岛空管站微信";
    [self.view addSubview:WXLabel];
    
    [self.view addSubview:QRImg];
    
    //微信关注2
    UIImageView *QRImg1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personal_wx1"]];
    
    QRImg1.frame = CGRectMake(FrameWidth(213), FrameWidth(470)+ Height_NavBar, FrameWidth(213), FrameWidth(213));
    
    UILabel *WXLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(20),FrameWidth(690) ,FrameWidth(600), FrameWidth(20))];
    WXLabel1.textAlignment = NSTextAlignmentCenter;
    WXLabel1.textColor = [UIColor lightGrayColor];
    WXLabel1.font = FontSize(14);
    WXLabel1.text = @"航景在线微信";
    [self.view addSubview:WXLabel1];
    
    [self.view addSubview:QRImg1];
    
    
    //电话地址官网
    UILabel * mobileLabel = [[UILabel alloc] initWithFrame:CGRectMake( FrameWidth(120),  FrameWidth(820)+ Height_NavBar, WIDTH_SCREEN, FrameWidth(40))];
    mobileLabel.text = @"合作联系：0532-86126771";
    mobileLabel.font = FontSize(14);
    [self.view addSubview:mobileLabel];
    
    UILabel * addressLabel = [[UILabel alloc] initWithFrame:CGRectMake( FrameWidth(120),  FrameWidth(860)+ Height_NavBar, WIDTH_SCREEN, FrameWidth(40))];
    addressLabel.text = @"问题反馈：0532-86126771";
    addressLabel.font = FontSize(14);
    [self.view addSubview:addressLabel];
    
    
    UILabel * webLabel = [[UILabel alloc] initWithFrame:CGRectMake( FrameWidth(120),  FrameWidth(900)+ Height_NavBar, WIDTH_SCREEN, FrameWidth(40))];
    webLabel.text = @"公司地址：青岛市城阳区民航路117号";
    webLabel.font = FontSize(14);
    [self.view addSubview:webLabel];
    
}

-(void)backBtn{
    UIButton *leftButon = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButon.frame = CGRectMake(0,0,FrameWidth(60),FrameWidth(60));
    [leftButon setImage:[UIImage imageNamed:@"back_icon"] forState:UIControlStateNormal];
    [leftButon setContentEdgeInsets:UIEdgeInsetsMake(0, - FrameWidth(20), 0, FrameWidth(20))];
    //button.alignmentRectInsetsOverride = UIEdgeInsetsMake(0, offset, 0, -(offset));
    [leftButon addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc]initWithCustomView:leftButon];
    self.navigationItem.leftBarButtonItem = fixedButton;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    
}
-(void)backAction {
    //[self dismissViewControllerAnimated:YES completion:nil];
    //return ;
    //[self.navigationController pushViewController:[[FrameLoginController alloc]init] animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)createNaviTopView {
    
    UIImageView *topImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT +44)];
    [self.view addSubview:topImage1];
    topImage1.backgroundColor  =[UIColor clearColor];
    UIImageView *topImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAVIGATIONBAR_HEIGHT + 44)];
    [self.view addSubview:topImage];
    topImage.backgroundColor  =[UIColor clearColor];
    topImage.image = [self createImageWithColor:[UIColor clearColor]];
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
    self.titleLabel.text = @"关注我们";
    
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



@end





