//
//  KG_NewTarBarViewController.m
//  Frame
//
//  Created by zhangran on 2020/4/7.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_NewTarBarViewController.h"
#import "FrameHomeController.h"
#import "AlarmListController.h"
#import "StationDetailController.h"
#import "PatrolController.h"
#import "DataCenterViewController.h"
#import "FrameNavigationController.h"
@interface KG_NewTarBarViewController ()

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
    
    FrameHomeController *oneVC = [[FrameHomeController alloc]init];
    [self setUpOneChildViewController:oneVC image:[UIImage imageNamed:@"mystation_unsel"] image2:[UIImage imageNamed:@"mystation_sel"] title:@"我的台站1"  type:1];
    // 添加第2个控制器
    AlarmListController *twoVC = [[AlarmListController alloc]init];
    [self setUpOneChildViewController:twoVC image:[UIImage imageNamed:@"zhixiu_unsel"] image2:[UIImage imageNamed:@"zhixiu_sel"] title:@"智修"  type:0];
    
    
    //[self.tabBar setBackgroundImage:[UIImage imageNamed:@"//main_tab_bg"]];
    
    // 添加第3个控制器
    StationDetailController *threeVC = [[StationDetailController alloc]init];
    [self setUpOneChildViewController:threeVC image:[UIImage imageNamed:@"task_unsel"] image2:[UIImage imageNamed:@"task_sel"] title:@"任务"  type:0];
    
    // 添加第4个控制器
    PatrolController *fourVC = [[PatrolController alloc]init];
    [self setUpOneChildViewController:fourVC image:[UIImage imageNamed:@"zhiyun_unsel"] image2:[UIImage imageNamed:@"zhiyun_sel"] title:@"智云"  type:0];
    // 添加第5个控制器
    DataCenterViewController *fiveVC = [[DataCenterViewController alloc]init];
    [self setUpOneChildViewController:fiveVC image:[UIImage imageNamed:@"mine_unsel"] image2:[UIImage imageNamed:@"mine_sel"] title:@"我的"  type:0];
    [self setSelectedIndex:0];
    self.selectedIndex = 0;
    self.tabBarController.selectedIndex = 0;
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
    
    self.tabBar.tintColor = [UIColor colorWithHexString:@"##0E59AB"];
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

@end
