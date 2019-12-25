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

@end

@implementation PersonalFollowUsController

//static NSString * const reuseIdentifier = @"Cell";


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关注我们";
    [self backBtn];
    [self loadBgView];
    
}
-(void)loadBgView{
    //背景色
    self.view.backgroundColor =  [UIColor  colorWithPatternImage:[UIImage imageNamed:@"personal_gray_bg"]] ;
    //logo和版本
    UIImageView *logoImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    
    logoImg.frame = CGRectMake( FrameWidth(270),  FrameWidth(55),  FrameWidth(100),  FrameWidth(100));
    
    UILabel *vsersionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, FrameWidth(170) , WIDTH_SCREEN,  FrameWidth(20))];
    vsersionLabel.textAlignment = NSTextAlignmentCenter;
    vsersionLabel.textColor = [UIColor lightGrayColor];
    vsersionLabel.font = FontSize(14);
    vsersionLabel.text = AppVersion;
    [self.view addSubview:vsersionLabel];
    
    [self.view addSubview:logoImg];
    //微信关注
    UIImageView *QRImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personal_wx"]];
    
    QRImg.frame = CGRectMake(FrameWidth(213), FrameWidth(210), FrameWidth(213), FrameWidth(213));
    
    UILabel *WXLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(20),FrameWidth(440) ,FrameWidth(600), FrameWidth(20))];
    WXLabel.textAlignment = NSTextAlignmentCenter;
    WXLabel.textColor = [UIColor lightGrayColor];
    WXLabel.font = FontSize(14);
    WXLabel.text = @"青岛空管站微信";
    [self.view addSubview:WXLabel];
    
    [self.view addSubview:QRImg];
    
    //微信关注2
    UIImageView *QRImg1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personal_wx1"]];
    
    QRImg1.frame = CGRectMake(FrameWidth(213), FrameWidth(470), FrameWidth(213), FrameWidth(213));
    
    UILabel *WXLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(20),FrameWidth(690) ,FrameWidth(600), FrameWidth(20))];
    WXLabel1.textAlignment = NSTextAlignmentCenter;
    WXLabel1.textColor = [UIColor lightGrayColor];
    WXLabel1.font = FontSize(14);
    WXLabel1.text = @"航景在线微信";
    [self.view addSubview:WXLabel1];
    
    [self.view addSubview:QRImg1];
    
    
    //电话地址官网
    UILabel * mobileLabel = [[UILabel alloc] initWithFrame:CGRectMake( FrameWidth(120),  FrameWidth(820), WIDTH_SCREEN, FrameWidth(40))];
    mobileLabel.text = @"合作联系：0532-86126771";
    mobileLabel.font = FontSize(14);
    [self.view addSubview:mobileLabel];
    
    UILabel * addressLabel = [[UILabel alloc] initWithFrame:CGRectMake( FrameWidth(120),  FrameWidth(860), WIDTH_SCREEN, FrameWidth(40))];
    addressLabel.text = @"问题反馈：0532-86126771";
    addressLabel.font = FontSize(14);
    [self.view addSubview:addressLabel];
    
    
    UILabel * webLabel = [[UILabel alloc] initWithFrame:CGRectMake( FrameWidth(120),  FrameWidth(900), WIDTH_SCREEN, FrameWidth(40))];
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



@end





