//
//  WYLNavigationController.m
//  ylh-app-primary-ios
//
//  Created by 巨商汇 on 2019/6/12.
//  Copyright © 2019 巨商汇. All rights reserved.
//



#import "WYLNavigationController.h"

@interface WYLNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation WYLNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置划屏返回手势的代理,与用户交互的手势代理
    self.interactivePopGestureRecognizer.delegate = self;
    
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
  //先判断,后push控制器,push之前,导航控制器的childViewControllers数组当中没有子控制器,所以第一个子控制器添加的时候为0,第二个子控制器添加的时候就是1,
    if (self.childViewControllers.count >= 1) {
        
        //再push出来的控制器,设置隐藏tabBar条
        viewController.hidesBottomBarWhenPushed = YES;
        
    }
    
    //调用父类的push方法
    //super的push方法一定要写到后面
    //一旦调用super的 pushViewController方法,就会创建子控制器viewController的view,就会调用子控制器viewController的viewDidLoad方法,
    //否则的话,那么后面统一设置的导航条左边的返回按钮就会覆盖子控制器对导航条左边的按钮进行的一些个性化设置
    [super pushViewController:viewController animated:animated];
    
}

#pragma mark ------- UIGestureRecognizerDelegate代理方法
/**
 *  每当用户触发返回手势的时候都会调用这个方法
 *  返回值:YES 手势有效;返回值:NO,手势失效
 *  如果当前显示的是第一个子控制器,就应该禁止返回手势
 */
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    //    if (self.childViewControllers.count == 1) {
    //        return NO;
    //    }
    //
    //    return YES;
    
    return self.childViewControllers.count > 1;
}

@end
