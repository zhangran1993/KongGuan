//
//  MBProgressHUD+XMG.h
//
//  Created by xiaomage on 15-6-6.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "MBProgressHUD+XMG.h"
#import "RS_ColorManager.h"
@implementation MBProgressHUD (XMG)
#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    /** 添加MBProgressHUD之前,先for循环view上的所有子控件,如果发现是MBProgressHUD,就从父控件上移除 **/
    /** 避免每次添加MBProgressHUD之前,view上已经存在MBProgressHUD,导致多个MBProgressHUD重叠显示 **/
//    for (UIView *aView in view.subviews) {
//        if ([aView isKindOfClass:self]) {
//            [aView removeFromSuperview];
//        }
//    }
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //    hud.labelText = text;把这一行 换成下面这一行就可以自动换行了
    hud.detailsLabel.text = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;

    hud.label.font = [UIFont systemFontOfSize:14]; //设置字体(这句没用，因为使用了detailsLabelText)

    //MBProgressHUDBackgroundStyleSolidColor这个枚举值是实心颜色的意思，在这个枚举的基础上，你可以设置任意你想要的颜色。bezelView的另外一个枚举值是MBProgressHUDBackgroundStyleBlur，意思是 毛玻璃，如果设置了这个枚举值， 那么你不管设置什么颜色都不会有半透明效果。
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    //设置背景色和透明度
    hud.bezelView.backgroundColor = [UIColor colorWithHexString:@"#222222"];
    hud.bezelView.alpha =0.7;
    //设置字体颜色
    hud.detailsLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    hud.detailsLabel.font = FontBold(16); // 蓝湖：一级+通用+弹窗-toast 版本1

    hud.margin = 10.f;
    //    hud.yOffset = 15.f;
    [hud setOffset:CGPointMake(hud.offset.x, 15.f)];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    hud.userInteractionEnabled = NO;


    // 1.5秒之后再消失
    //    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC));
    //    WS(weakSelf)
    //    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
    //        hud.hidden = YES;
    //    });

    [hud hideAnimated:YES afterDelay:3];
}

/** 自定义消失时间 **/
+ (void)show:(NSString *)message icon:(NSString *)icon toView:(UIView *)view afterDelay:(NSTimeInterval)delay{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    /** 添加MBProgressHUD之前,先for循环view上的所有子控件,如果发现是MBProgressHUD,就从父控件上移除 **/
    /** 避免每次添加MBProgressHUD之前,view上已经存在MBProgressHUD,导致多个MBProgressHUD重叠显示 **/
//    for (UIView *aView in view.subviews) {
//        if ([aView isKindOfClass:self]) {
//            [aView removeFromSuperview];
//        }
//    }
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //    hud.labelText = text;把这一行 换成下面这一行就可以自动换行了
    hud.detailsLabel.text = message;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:icon]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;

    hud.label.font = [UIFont systemFontOfSize:14]; //设置字体(这句没用，因为使用了detailsLabelText)

    //MBProgressHUDBackgroundStyleSolidColor这个枚举值是实心颜色的意思，在这个枚举的基础上，你可以设置任意你想要的颜色。bezelView的另外一个枚举值是MBProgressHUDBackgroundStyleBlur，意思是 毛玻璃，如果设置了这个枚举值， 那么你不管设置什么颜色都不会有半透明效果。
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    //设置背景色和透明度
    hud.bezelView.backgroundColor = [UIColor colorWithHexString:@"#222222" alpha:0.7];
    //设置字体颜色
    hud.detailsLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    hud.detailsLabel.font = FontBold(16); // 蓝湖：一级+通用+弹窗-toast 版本1

    hud.margin = 10.f;
    //    hud.yOffset = 15.f;
    [hud setOffset:CGPointMake(hud.offset.x, 15.f)];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;

    // 1.5秒之后再消失
    //    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC));
    //    WS(weakSelf)
    //    dispatch_after(delayTime, dispatch_get_main_queue(), ^{
    //        hud.hidden = YES;
    //    });

    [hud hideAnimated:YES afterDelay:delay];
}



#pragma mark ---- 显示自定义时间提示信息
+ (void)showError:(NSString *)error toView:(UIView *)view afterDelay:(NSTimeInterval)delay{
    [self show:error icon:@"newError" toView:view afterDelay:delay ];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view afterDelay:(NSTimeInterval)delay{
    [self show:success icon:@"newSuccess" toView:view afterDelay:delay];
}

+ (void)show:(NSString *)message toView:(UIView *)view afterDelay:(NSTimeInterval)delay{
    [self show:message icon:@"" toView:view afterDelay:delay];
}

#pragma mark 显示信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"newError" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view{
    [self show:success icon:@"newSuccess" view:view];
}


+ (void)show:(NSString *)message toView:(UIView *)view{
    [self show:message icon:@"" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view
{
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    
    /** 添加MBProgressHUD之前,先for循环view上的所有子控件,如果发现是MBProgressHUD,就从父控件上移除 **/
    /** 避免每次添加MBProgressHUD之前,view上已经存在MBProgressHUD,导致多个MBProgressHUD重叠显示 **/
//    for (UIView *aView in view.subviews) {
//        if ([aView isKindOfClass:self]) {
//            [aView removeFromSuperview];
//        }
//    }
//    

    //设置菊花框为白色
    [UIActivityIndicatorView appearanceWhenContainedIn:[MBProgressHUD class], nil].color = [UIColor whiteColor]; //菊花 全局设置
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    //MBProgressHUDBackgroundStyleSolidColor这个枚举值是实心颜色的意思，在这个枚举的基础上，你可以设置任意你想要的颜色。bezelView的另外一个枚举值是MBProgressHUDBackgroundStyleBlur，意思是 毛玻璃，如果设置了这个枚举值， 那么你不管设置什么颜色都不会有半透明效果。
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    //设置背景色和透明度
    hud.bezelView.backgroundColor = [UIColor colorWithHexString:@"#222222"];
    hud.bezelView.alpha =0.7;
    //设置字体颜色
    hud.label.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    // YES代表需要蒙版效果
    hud.backgroundView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.backgroundView.color =  [UIColor colorWithWhite:0.f alpha:.2f];
    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}
@end
