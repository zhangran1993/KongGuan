//
//  FrameViewController.m
//   
//
//  Created by Hibaysoft on 17/7/4.
//  Copyright (c) 2018年 Hibaysoft. All rights reserved.
//

#import "FrameViewController.h"
#import "FrameTabBarController.h"

@interface FrameViewController ()

@end

@implementation FrameViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //    // 如果A控制器的view成为B控制器的view的子控件,那么A控制器成为B控制器的子控制器
    //
    FrameTabBarController *tabBarVc = [[FrameTabBarController alloc] init];

    
    // 添加子控制器
    [self addChildViewController:tabBarVc];


}


@end
