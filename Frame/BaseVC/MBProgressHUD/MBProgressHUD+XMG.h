//
//  MBProgressHUD+XMG.h
//
//  Created by xiaomage on 15-6-6.
//  Copyright (c) 2015年 xiaomage. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (XMG)

+ (MBProgressHUD *)showMessage:(NSString *)message;
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success;
+ (void)showError:(NSString *)error;


/** 显示信息 **/
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)show:(NSString *)message toView:(UIView *)view;

/** 显示自定义时间提示信息 **/
+ (void)showError:(NSString *)error toView:(UIView *)view afterDelay:(NSTimeInterval)delay;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view afterDelay:(NSTimeInterval)delay;
+ (void)show:(NSString *)message toView:(UIView *)view afterDelay:(NSTimeInterval)delay;

/** 隐藏提示框 **/
+ (void)hideHUDForView:(UIView *)view;
+ (void)hideHUD;

@end
