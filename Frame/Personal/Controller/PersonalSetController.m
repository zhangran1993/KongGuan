//
//  PersonalSetController.m
//  Frame
//
//  Created by hibayWill on 2018/3/17.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "PersonalSetController.h"
#import "PersonalEditPwdController.h"
#import "PersonalAboutUsController.h"
#import "FrameBaseRequest.h"
#import "JPUSHService.h"

@interface PersonalSetController ()<JPUSHRegisterDelegate>{
    int timeCont;
    NSTimer *timer;
}

@property(strong,nonatomic)UIImageView *setMsgImg;


@property (nonatomic, strong)  UILabel   *titleLabel;
@property (nonatomic, strong)  UIView    *navigationView;
@property (nonatomic, strong)  UIButton  *rightButton;

@end

@implementation PersonalSetController

//static NSString * const reuseIdentifier = @"Cell";


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNaviTopView];
    
   
    if (@available(iOS 13.0, *)){
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDarkContent;
    }else {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    [self.navigationController setNavigationBarHidden:YES];
    
    self.title = @"设置";
    [self backBtn];
    [self loadBgView];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"viewWillDisappear");
}

-(void)loadBgView{
    timeCont = 60;
    
    //背景色
    self.view.backgroundColor =  [UIColor  colorWithPatternImage:[UIImage imageNamed:@"personal_gray_bg"]] ;
    //消息通知
    UIView *setMsgView = [[UIView alloc] initWithFrame:CGRectMake(0, FrameWidth(20)+ Height_NavBar, WIDTH_SCREEN, FrameWidth(80))];
    setMsgView.backgroundColor = [UIColor whiteColor];
    UILabel *setMsgLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(20), 0, WIDTH_SCREEN/2,FrameWidth(80))];
    setMsgLabel.text = @"消息通知";
    setMsgLabel.font = FontSize(17);
    setMsgLabel.textColor = [UIColor grayColor];
    [setMsgView addSubview:setMsgLabel];
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *newsSet = [userDefaults objectForKey:@"newsSet"];
    NSLog(@"newsSet           %@",newsSet);
    if(!newsSet||[newsSet isEqualToString:@""]||[newsSet isEqual:[NSNull null]]||[newsSet isEqualToString:@"personal_opennews"]){
        newsSet = @"personal_opennews";
    }else{
        newsSet = @"personal_closenews";
    }
    
    _setMsgImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:newsSet]];
    
    _setMsgImg.frame = CGRectMake(WIDTH_SCREEN-FrameWidth(95), FrameWidth(20), FrameWidth(78), FrameWidth(45));
    
    [_setMsgImg setUserInteractionEnabled:YES];
    [_setMsgImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setMsg)]];
    [setMsgView addSubview:_setMsgImg];
    [self.view addSubview:setMsgView];
    //修改密码
    UIView *editPwdView = [[UIView alloc] initWithFrame:CGRectMake(0, FrameWidth(118)+Height_NavBar, WIDTH_SCREEN, FrameWidth(80))];
    editPwdView.backgroundColor = [UIColor whiteColor];
    [editPwdView setUserInteractionEnabled:YES];
    [editPwdView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPwd)]];
    UILabel *editPwdLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(20), 0, WIDTH_SCREEN/2,FrameWidth(80))];
    editPwdLabel.text = @"设置";
    editPwdLabel.font = FontSize(17);
    editPwdLabel.textColor = [UIColor grayColor];
    [editPwdView addSubview:editPwdLabel];
    
    UIImageView *editPwdImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personal_gray_right"]];
    
    editPwdImg.frame = CGRectMake(WIDTH_SCREEN-FrameWidth(35), FrameWidth(28), FrameWidth(15), FrameWidth(20));
    [editPwdView addSubview:editPwdImg];
    [self.view addSubview:editPwdView];
    
    //关于我们
    UIView *aboutUsView = [[UIView alloc] initWithFrame:CGRectMake(0, FrameWidth(214)+Height_NavBar, WIDTH_SCREEN, FrameWidth(80))];
    aboutUsView.backgroundColor = [UIColor whiteColor];
    [aboutUsView setUserInteractionEnabled:YES];
    [aboutUsView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(aboutUs)]];
    UILabel *aboutUsLabel = [[UILabel alloc] initWithFrame:CGRectMake(FrameWidth(20), 0, WIDTH_SCREEN/2,FrameWidth(80))];
    aboutUsLabel.text = @"关于我们";
    aboutUsLabel.font = FontSize(17);
    aboutUsLabel.textColor = [UIColor grayColor];
    [aboutUsView addSubview:aboutUsLabel];
    
    UIImageView *aboutUsImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personal_gray_right"]];
    
    aboutUsImg.frame = CGRectMake(WIDTH_SCREEN-FrameWidth(35), FrameWidth(28), FrameWidth(15), FrameWidth(20));
    
    [aboutUsView addSubview:aboutUsImg];
    [self.view addSubview:aboutUsView];
    
}
-(void)editPwd {
    
    PersonalEditPwdController *EditPwdController = [[PersonalEditPwdController alloc] init];
    [self.navigationController pushViewController:EditPwdController animated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
    //return ;
    //[self.navigationController pushViewController:[[FrameLoginController alloc]init] animated:YES];
}

-(void)aboutUs {
    PersonalAboutUsController *AboutUs = [[PersonalAboutUsController alloc] init];
    [self.navigationController pushViewController:AboutUs animated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
    //return ;
    //[self.navigationController pushViewController:[[FrameLoginController alloc]init] animated:YES];
    //[self.navigationController popViewControllerAnimated:YES];
}


-(void)setMsg{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *newsSet = [userDefaults objectForKey:@"newsSet"];
    if([newsSet isEqualToString:@"personal_closenews"]){
        [userDefaults setObject:@"personal_opennews" forKey:@"newsSet"];
        [_setMsgImg setImage:[UIImage imageNamed:@"personal_opennews"]];
        
        /*极光推送*/
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
        
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
        [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
            NSLog(@"resCode : %d,registrationID: %@",resCode,registrationID);
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            if(!registrationID){
                registrationID = @"myAppTest";
            }
            [userDefaults setObject:registrationID forKey:@"registrationID"];
        }];
        // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
        [JPUSHService setupWithOption:[userDefaults objectForKey:@"launchOptions"] appKey: @"6787538ae7be7e273b69703f" channel:@"AppStore" apsForProduction:FALSE];
        
        
    }else{
        [userDefaults setObject:@"personal_closenews" forKey:@"newsSet"];
        [_setMsgImg setImage:[UIImage imageNamed:@"personal_closenews"]];
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation2"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)application:(UIApplication *) application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken{
    [JPUSHService setBadge:0];
    [JPUSHService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSLog(@"AppDelegate willPresentNotification收到通知");
    
}

- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)( ))completionHandler {
    NSLog(@"AppDelegate willPresentNotification收到通知");
}





- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
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
    self.titleLabel.text = @"修改密码";
    
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


