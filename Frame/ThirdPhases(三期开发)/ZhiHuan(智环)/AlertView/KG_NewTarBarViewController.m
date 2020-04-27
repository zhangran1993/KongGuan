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
@interface KG_NewTarBarViewController ()<UINavigationControllerDelegate>

@end

@implementation KG_NewTarBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpAllChildViewController];
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
    [self setUpOneChildViewController:oneVC image:[UIImage imageNamed:@"mystation_unsel"] image2:[UIImage imageNamed:@"mystation_sel"] title:@"智环"  type:1];
    // 添加第2个控制器
    KG_ZhiTaiViewController *twoVC = [[KG_ZhiTaiViewController alloc]init];
    [self setUpOneChildViewController:twoVC image:[UIImage imageNamed:@"zhixiu_unsel"] image2:[UIImage imageNamed:@"zhixiu_sel"] title:@"智态"  type:0];
    
    
    //[self.tabBar setBackgroundImage:[UIImage imageNamed:@"//main_tab_bg"]];
    
    // 添加第3个控制器
    KG_ZhiWeiViewController *threeVC = [[KG_ZhiWeiViewController alloc]init];
    [self setUpOneChildViewController:threeVC image:[UIImage imageNamed:@"task_unsel"] image2:[UIImage imageNamed:@"task_sel"] title:@"智维"  type:0];
    
    // 添加第4个控制器
    PatrolController *fourVC = [[PatrolController alloc]init];
    [self setUpOneChildViewController:fourVC image:[UIImage imageNamed:@"zhiyun_unsel"] image2:[UIImage imageNamed:@"zhiyun_sel"] title:@"智修"  type:0];
    // 添加第5个控制器
    DataCenterViewController *fiveVC = [[DataCenterViewController alloc]init];
    [self setUpOneChildViewController:fiveVC image:[UIImage imageNamed:@"mine_unsel"] image2:[UIImage imageNamed:@"mine_sel"] title:@"智云"  type:0];
    [self setSelectedIndex:0];
    self.selectedIndex = 0;
    self.tabBarController.selectedIndex = 0;
}


/**
 *  添加一个子控制器的方法
 */
- (void)setUpOneChildViewController:(UIViewController *)viewController image:(UIImage *)image image2:(UIImage *)image2 title:(NSString *)title  type:(int )type{
    
    
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
    
    [self addChildViewController:viewController];
    
    
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
@end
