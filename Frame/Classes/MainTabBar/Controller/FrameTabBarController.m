//
//  FrameTabBarController.m
//   
//
//  Created by Hibaysoft on 17/7/4.
//  Copyright (c) 2018年 Hibaysoft. All rights reserved.
//

#import "FrameTabBarController.h"
#import "PersonalViewController.h"
#import "PatrolController.h"
#import "FrameHomeController.h"
#import "LoginViewController.h"
#import "StationDetailController.h"
#import "AlarmListController.h"
#import "DataCenterViewController.h"
#import "YQSlideMenuController.h"
#import "FrameNavigationController.h"

#import "FrameBaseRequest.h"

@interface FrameTabBarController ()<YQContentViewControllerDelegate>

@property (nonatomic,copy) NSString * downloadUrl;
@property (nonatomic,assign) NSInteger isShow;
@end

@implementation FrameTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpAllChildViewController];
    
    _isShow = 1;

}
-(void)viewDidAppear:(BOOL)animated{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if(![userDefaults objectForKey:@"userAccount"]||[[userDefaults objectForKey:@"userAccount"] isEqualToString:@""]){
        return ;
    }
    if(_isShow==1){
        _isShow = 0;
        [self isiOSUpdate];
    }
}
-(void)isiOSUpdate{
    // 请求参数（根据接口文档编写）
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:@"/api/getUpdateDetail/IOS"];
    params[@"var"] = AppVersion;
    [FrameBaseRequest getWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  == 0 &&![AppVersion isEqualToString:result[@"value"][@"version"]]){
            self.downloadUrl = result[@"value"][@"downloadUrl"];
            [self showUpdate:result[@"value"][@"description"] forceUpdate:[result[@"value"][@"forceUpdate"] boolValue]];
            //FrameUpdate.desc = result[@"value"][@"description"];
            return ;
        }
    } failure:^(NSURLSessionDataTask *error)  {
       
        FrameLog(@"请求失败，返回数据 : %@",error);
        return ;
    }];
    
}


- (void)createVC:(UIViewController *)vc Title:(NSString *)title imageName:(NSString *)imageName
{
    vc.title = title;
    
    self.tabBar.tintColor = [UIColor colorWithRed:75/255.0 green:144/255.0 blue:116/255.0 alpha:1];
    vc.tabBarItem.image = [UIImage imageNamed:imageName];
    NSString *imageSelect = [NSString stringWithFormat:@"%@_selected",imageName];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:imageSelect] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:[[UINavigationController alloc]initWithRootViewController:vc]];
}

/**
 *  添加所有子控制器
 */
- (void)setUpAllChildViewController{
    /*
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"main_tab_bg"]];
    if(HEIGHT_SCREEN == 812){
        imgView.frame = CGRectMake(self.tabBar.bounds.origin.x, self.tabBar.bounds.origin.y-45, self.tabBar.bounds.size.width, self.tabBar.bounds.size.height+15);
    }else{
        imgView.frame = CGRectMake(self.tabBar.bounds.origin.x, self.tabBar.bounds.origin.y-15, self.tabBar.bounds.size.width, self.tabBar.bounds.size.height+15);
    }
    //self.tabBar.bounds;
    imgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;//底部固定，调整顶部的距离//UIViewAutoresizingFlexibleHeight;//UIViewAutoresizingNone;//UIViewAutoresizingFlexibleWidth;
    [self.tabBar insertSubview:imgView atIndex:0];
    [self.tabBar setShadowImage:[UIImage new]];
    //[self.tabBar setBackgroundColor:[UIColor clearColor]];
    [self.tabBar setBackgroundImage:[UIImage new]];
    */
    [UITabBar appearance].translucent = NO;
    
    // 添加第1个控制器
    StationDetailController *oneVC = [[StationDetailController alloc]init];
    [self setUpOneChildViewController:oneVC image:[UIImage imageNamed:@"main_station"] image2:[UIImage imageNamed:@"main_station_s"] title:@"台站管理"  type:0];
    
    // 添加第2个控制器
    AlarmListController *twoVC = [[AlarmListController alloc]init];
    [self setUpOneChildViewController:twoVC image:[UIImage imageNamed:@"main_alarm"] image2:[UIImage imageNamed:@"main_alarm_s"] title:@"告警管理"  type:0];
    
    
    //[self.tabBar setBackgroundImage:[UIImage imageNamed:@"//main_tab_bg"]];
    
    // 添加第3个控制器
    FrameHomeController *threeVC = [[FrameHomeController alloc]init];
    [self setUpOneChildViewController:threeVC image:[UIImage imageNamed:@"main_home"] image2:[UIImage imageNamed:@"main_home_s"] title:@"首页"  type:1];
    
    // 添加第4个控制器
    PatrolController *fourVC = [[PatrolController alloc]init];
    [self setUpOneChildViewController:fourVC image:[UIImage imageNamed:@"main_Patrol"] image2:[UIImage imageNamed:@"main_Patrol_s"] title:@"巡查管理"  type:0];
    // 添加第5个控制器
    DataCenterViewController *fiveVC = [[DataCenterViewController alloc]init];
    [self setUpOneChildViewController:fiveVC image:[UIImage imageNamed:@"main_data"] image2:[UIImage imageNamed:@"main_data_s"] title:@"数据中心"  type:0];
    [self setSelectedIndex:2];
    self.selectedIndex = 2;
    self.tabBarController.selectedIndex = 2;
}


/**
 *  添加一个子控制器的方法
 */
- (void)setUpOneChildViewController:(UIViewController *)viewController image:(UIImage *)image image2:(UIImage *)image2 title:(NSString *)title  type:(int )type{
    
    FrameNavigationController *navC = [[FrameNavigationController alloc]initWithRootViewController:viewController];
    navC.title = title;
    navC.tabBarItem.image = image;
    navC.tabBarItem.selectedImage = image2;
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    navC.tabBarItem.titlePositionAdjustment = UIOffsetMake(0,-1);
    //navC.tabBarItem.imageInsets = UIEdgeInsetsMake(-3, 0, 3, 0);
    if(type == 2){
       
        /*
          navC.tabBarItem.imageInsets = UIEdgeInsetsMake(-21, 0, 21, 0);
        self.selectedIndex.currentSelectedIndex = 2;
        
        navC.tabBarItem.con
        [self.tabBarController setSelected:YES];
        navC.selectedIndex = 2;
        navC.tabBarItem.currentSelectedIndex = 2;
         */
    }
    
    self.tabBar.tintColor = [UIColor colorWithRed:100/255.0 green:170/255.0 blue:250/255.0 alpha:1];
    [navC.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigation"] forBarMetrics:UIBarMetricsDefault];
    viewController.navigationItem.title = title;
    // 字体大小 跟 normal
    NSMutableDictionary *attrnor = [NSMutableDictionary dictionary];
    
    // 设置字体
    attrnor[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    
    [navC.tabBarItem setTitleTextAttributes:attrnor forState:UIControlStateNormal];
    [navC.navigationBar setBarStyle:UIBarStyleBlack];
    [self addChildViewController:navC];
    
}

/**
 更新
 */
-(void)showUpdate:(NSString *) desc forceUpdate:(BOOL)forceUpdate{
    UIViewController *vc = [UIViewController new];
    
    vc.view.frame = CGRectMake(0, 0, WIDTH_SCREEN,  HEIGHT_SCREEN);
    vc.view.layer.masksToBounds = YES;
    
    UIView *commentView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH_SCREEN/9, HEIGHT_SCREEN/6, WIDTH_SCREEN*7/9, FrameWidth(685))];
    commentView.backgroundColor = [UIColor clearColor];
    [vc.view addSubview:commentView];
    
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_update_bg"]];
    imgView.frame = commentView.bounds;
    imgView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;//顶部固定，调整底部的距离
    
    [commentView insertSubview:imgView atIndex:0];
    
    UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(50), FrameWidth(220), FrameWidth(380), FrameWidth(35))];
    titleLabel.font = FontSize(14);
    titleLabel.text = @"更新功能说明：";
    [commentView addSubview:titleLabel];
    
    UILabel * descLabel = [[UILabel alloc]initWithFrame:CGRectMake(FrameWidth(50), FrameWidth(270), FrameWidth(390), FrameWidth(330))];
    descLabel.font = FontSize(14);
    descLabel.textColor = [UIColor lightGrayColor];
    descLabel.text = desc;
    //descLabel.textAlignment = NSTextAlignmentNatural;
    descLabel.lineBreakMode = NSLineBreakByCharWrapping;
    descLabel.numberOfLines = 0;
    
    CGRect txRect = [desc boundingRectWithSize:CGSizeMake(FrameWidth(390),FrameWidth(330)) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:descLabel.font} context:nil];
    descLabel.frame = CGRectMake(FrameWidth(50), FrameWidth(270),  FrameWidth(390), txRect.size.height);
    [commentView addSubview:descLabel];
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(FrameWidth(60),FrameWidth(600),FrameWidth(370),FrameWidth(55))];
    
    [button addTarget:self action:@selector(isUpadte) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"home_update_btn"] forState:UIControlStateNormal];
    
    [commentView addSubview:button];
    
    
    
    UIButton *CloseBtn = [[UIButton alloc]initWithFrame:CGRectMake(WIDTH_SCREEN*7/9 - FrameWidth(35),-FrameWidth(10),FrameWidth(50),FrameWidth(50))];
    
    [CloseBtn addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
    [CloseBtn setBackgroundImage:[UIImage imageNamed:@"home_update_close"] forState:UIControlStateNormal];
    
    [commentView addSubview:CloseBtn];
    if( forceUpdate){
        [CloseBtn setHidden:YES];
    }
    
    [self cb_presentPopupViewController:vc animationType:CBPopupViewAnimationSlideFromTop aligment:CBPopupViewAligmentTop overlayDismissed:nil];
}

-(void)isUpadte{
    [self cb_dismissPopupViewControllerAnimated:YES completion:nil];
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.downloadUrl]];
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/cn/app/id00000000?mt=8"]];
}

-(void)tapAction{
    [self cb_dismissPopupViewControllerAnimated:YES completion:nil];
}

-(UINavigationController *)NavController{
    return self.selectedViewController;
}
- (UINavigationController *)yq_navigationController {
    return self.selectedViewController;
}
@end
