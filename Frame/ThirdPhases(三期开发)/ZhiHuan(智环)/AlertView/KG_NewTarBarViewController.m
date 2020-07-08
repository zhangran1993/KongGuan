//
//  KG_NewTarBarViewController.m
//  Frame
//
//  Created by zhangran on 2020/4/7.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_NewTarBarViewController.h"
#import "FrameHomeController.h"
#import "KG_ZhiTaiViewController.h"
#import "StationDetailController.h"
#import "PatrolController.h"
#import "DataCenterViewController.h"
#import "FrameNavigationController.h"
#import "StationDetailController.h"
#import "KG_ZhiWeiViewController.h"
#import "KG_RunZhiYunViewController.h"
#import "KG_ZhiXiuViewController.h"
#import "KG_RunManagerViewController.h"

#import "PersonalViewController.h"
#import "PatrolController.h"
#import "FrameHomeController.h"
#import "LoginViewController.h"
#import "StationDetailController.h"
#import "AlarmListController.h"
#import "DataCenterViewController.h"
#import "YQSlideMenuController.h"
#import "FrameNavigationController.h"
#import "KG_RunZhiYunViewController.h"
#import "FrameBaseRequest.h"
@interface KG_NewTarBarViewController ()<UINavigationControllerDelegate,YQContentViewControllerDelegate>

@property (nonatomic,copy) NSString * downloadUrl;
@property (nonatomic,assign) NSInteger isShow;

@end

@implementation KG_NewTarBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpAllChildViewController];
     _isShow = 1;
    // Do any additional setup after loading the view.
    //    threeViewController *QuizVC = [[threeViewController alloc]init];
    //    QuizVC.tabBarItem.title = @"11";
    //    QuizVC.tabBarItem.image = [UIImage imageNamed:@"smiley_223"];
    //    UINavigationController *QuizNav = [[UINavigationController alloc]initWithRootViewController:QuizVC];
    //
    //    fourViewController *MoreVC = [[fourViewController alloc]init];
    //    MoreVC.tabBarItem.title = @"22";
    //    MoreVC.tabBarItem.image = [UIImage imageNamed:@"smiley_213"];
    //    UINavigationController *MoreNav = [[UINavigationController alloc]initWithRootViewController:MoreVC];
    //
    //    [self setViewControllers:@[QuizNav,MoreNav] animated:YES];
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
    //    [UITabBar appearance].translucent = NO;
    
    // 添加第1个控制器
    //    StationDetailController *oneVC = [[StationDetailController alloc]init];
    //    [self setUpOneChildViewController:oneVC image:[UIImage imageNamed:@"mystation_unsel"] image2:[UIImage imageNamed:@"mystation_sel"] title:@"我的台站"  type:1];
    //
    
    StationDetailController *oneVC = [[StationDetailController alloc]init];
    [self setUpOneChildViewController:oneVC image:[UIImage imageNamed:@"智环"] image2:[UIImage imageNamed:@"智环_sel"] title:@"智环"  type:1];
    // 添加第2个控制器
    KG_ZhiTaiViewController *twoVC = [[KG_ZhiTaiViewController alloc]init];
    [self setUpOneChildViewController:twoVC image:[UIImage imageNamed:@"智态"] image2:[UIImage imageNamed:@"智态_sel"] title:@"智态"  type:0];
    
    
    //[self.tabBar setBackgroundImage:[UIImage imageNamed:@"//main_tab_bg"]];
    
    // 添加第3个控制器
    KG_RunManagerViewController *threeVC = [[KG_RunManagerViewController alloc]init];
    [self setUpOneChildViewController:threeVC image:[UIImage imageNamed:@"运行管理"] image2:[UIImage imageNamed:@"运行管理_sel"] title:@"运行"  type:0];
    // 添加第4个控制器
    KG_ZhiXiuViewController *fourVC = [[KG_ZhiXiuViewController alloc]init];
    [self setUpOneChildViewController:fourVC image:[UIImage imageNamed:@"智修"] image2:[UIImage imageNamed:@"智修_sel"] title:@"智修"  type:0];
    
    // 添加第5个控制器
    KG_ZhiWeiViewController *fiveVC= [[KG_ZhiWeiViewController alloc]init];
       [self setUpOneChildViewController:fiveVC image:[UIImage imageNamed:@"智维"] image2:[UIImage imageNamed:@"智维_sel"] title:@"智维"  type:0];
    
    
    [self setSelectedIndex:2];
    self.selectedIndex = 2;
    self.tabBarController.selectedIndex = 2;
}


/**
 *  添加一个子控制器的方法
 */
- (void)setUpOneChildViewController:(UIViewController *)viewController image:(UIImage *)image image2:(UIImage *)image2 title:(NSString *)title  type:(int )type{
    
    FrameNavigationController *navC = [[FrameNavigationController alloc]initWithRootViewController:viewController];
    viewController.tabBarItem.title = title;
    viewController.tabBarItem.image = image;
    viewController.tabBarItem.selectedImage = image2;
    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    viewController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0,-1);
    
    
    self.tabBar.tintColor = [UIColor colorWithHexString:@"#0E59AB"];
    
    viewController.navigationItem.title = title;
    // 字体大小 跟 normal
    NSMutableDictionary *attrnor = [NSMutableDictionary dictionary];
    
    // 设置字体
    attrnor[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    
    [self addChildViewController:navC];
    // 默认
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    attrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#BDC2CC"];
    [viewController.tabBarItem setTitleTextAttributes:attrs forState:UIControlStateNormal];
    
    // 选中
    NSMutableDictionary *attrSelected = [NSMutableDictionary dictionary];
    attrSelected[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    attrSelected[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"#0E59AB"];
    [viewController.tabBarItem setTitleTextAttributes:attrSelected forState:UIControlStateNormal];

}

- (UIImage *)createImageWithColor: (UIColor *)color;
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillAppear");
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.navigationController setNavigationBarHidden:YES];
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"StationDetailController viewWillAppear");
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self.navigationController setNavigationBarHidden:NO];
    
    
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



@end
