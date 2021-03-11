//
//  AppDelegate.m
//   
//
//  Created by Hibaysoft on 17/7/4.
//  Copyright (c) 2018年 Hibaysoft. All rights reserved.
//

#import "AppDelegate.h"
#import "FrameViewController.h"
#import "KG_NewTarBarViewController.h"
#import "FrameBaseRequest.h"
#import "JPUSHService.h"
#import "PersonalViewController.h"
#import "YQSlideMenuController.h"
#import <Bugly/Bugly.h>
#import "MSLaunchView.h"
#import "UIImageView+WebCache.h"
#import <AFNetworkReachabilityManager.h>
#import "UIColor+Extension.h"

// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>

#import "StationDetailController.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
//蒲公英
//#import <PgySDK/PgyManager.h>
//#import <PgyUpdate/PgyUpdateManager.h>

#endif
#define BUGLY_APP_ID @"f4004224f8"
#define APPKEY @"13136a0d56bea32e57f518db"
@interface AppDelegate ()<JPUSHRegisterDelegate,UITabBarControllerDelegate,BuglyDelegate>
@property (strong, nonatomic) UIView *ADView;

@property (strong, nonatomic) NSDictionary *datDic;
@end

@implementation AppDelegate
+ (AppDelegate *)getAppDelegate{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    _mapManager = [[BMKMapManager alloc]init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [_mapManager start:@"vZK7X3GEuWKvP6aZhiPRgi7B1NQE6i1j"  generalDelegate:nil];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isFirstView"];
    if(![userDefaults objectForKey:@"newsSet"]){
        [userDefaults setObject:launchOptions forKey:@"launchOptions"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    /*极光推送*/
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        NSLog(@"resCode : %d,registrationID: %@",resCode,registrationID);
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if(!registrationID){
            registrationID = @"myAppTest";
        }
        [userDefaults setObject:registrationID forKey:@"registrationID"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }];
 
    
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey: @"6787538ae7be7e273b69703f" channel:@"AppStore" apsForProduction:FALSE];

    //bug采集
    [self setupBugly];
    //[JPUSHService setupWithOption:launchOptions appKey: @"6787538ae7be7e273b69703f" channel:@"AppStore"  apsForProduction:FALSE advertisingIdentifier:advertisingId];
    
    
    // 1.创建窗口
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];

    // 2.设置窗口的根控制器
    KG_NewTarBarViewController *FrameTabBar = [[KG_NewTarBarViewController alloc] init];
    FrameTabBar.delegate = self;
    // 3.显示窗口
    //[self.window makeKeyAndVisible];
    PersonalViewController *vc = [PersonalViewController new];
    YQSlideMenuController *sideMenuController = [[YQSlideMenuController alloc] initWithContentViewController:FrameTabBar
                                                                                      leftMenuViewController:vc];
    sideMenuController.scaleContent = NO;
    self.window.rootViewController = sideMenuController;
    [self.window makeKeyAndVisible];

    if ([CommonExtension isFirstLauch] == 1) {
        // [self guideData];
    }
    
    //[self loadAdView];
    [self checkNetWorkTrans];
    NSDictionary *userInfo=[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    self.datDic = userInfo;
    
    if (userInfo.count >0) {
        [self performSelector:@selector(alwaysShows) withObject:nil afterDelay:1.f];
    }
    /*
   
     */
    //蒲公英
    //启动基本SDK
    //[[PgyManager sharedPgyManager] startManagerWithAppId:@"PGY_APP_ID"];
    //启动更新检查SDK
    //[[PgyUpdateManager sharedPgyManager] startManagerWithAppId:@"PGY_APP_ID"];

    return YES;
}
- (void)alwaysShows {
     [[NSNotificationCenter defaultCenter]postNotificationName:@"alertMessage" object:nil userInfo:self.datDic];
}

/**
 监听网络状态
 */
- (void)checkNetWorkTrans {
    AFNetworkReachabilityManager *managerAF = [AFNetworkReachabilityManager sharedManager];
    [managerAF startMonitoring];
    [managerAF setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知的网络类型");
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"通过WIFI上网");
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"通过3G/4G上网");
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isNetwork"];
                //[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"isNetwork"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkStatusNotification object:self];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"当前网络不可达");
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isNetwork"];
                //[[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"isNetwork"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkStatusNotification object:self];
                break;
        }
    }];
}



/*
-(void)loadAdView{
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:@"/api/getAppPicture/screen"];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        NSMutableArray *imageArray = [NSMutableArray array];
        
        if (![self isBlankString:result[@"value"][0]]) {
            NSString * imageUrl = [NSString stringWithFormat:@"%@%@",WebHost,result[@"value"][0]];
            if ([self isFirstLauch]) {
                [self guideData:imageUrl];
            }else{
                MSLaunchView *view = [MSLaunchView launchWithImage:imageUrl launchWithImages:imageArray];
                                      
                                      //launchWithImage:result[@"value" ]];
                view.nomalColor = [UIColor lightGrayColor];
                view.currentColor = [UIColor orangeColor];
            }
        }
        
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
    }];
}
*/

#pragma mark - 判断是不是首次登录或者版本更新

/**
引导页
 */
- (void)guideData {
    NSString *  FrameRequestURL = [WebHost stringByAppendingString:@"/api/getAppPicture/guide"];
    [FrameBaseRequest getWithUrl:FrameRequestURL param:nil success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        NSMutableArray *imageArray = [NSMutableArray array];
        if (result[@"value"] || [result[@"value"] isKindOfClass:[NSArray class]] || [result[@"value"] count] > 0) {
            for (int i = 0; i < [result[@"value"] count]; i ++) {
                NSString *ImageURL = result[@"value"][i];
                ImageURL = [NSString stringWithFormat:@"%@%@",WebHost,ImageURL];
                [imageArray addObject:ImageURL];
            }
//            MSLaunchView *view = [MSLaunchView  launchWithImages:imageArray];
            MSLaunchView *view = [MSLaunchView launchWithImages:imageArray guideFrame:CGRectMake(0, HEIGHT_SCREEN - 45, WIDTH_SCREEN, 45) gImage:[self createImageWithColor:navigationColor]];
            view.nomalColor = [UIColor colorWithHexString:@"c9c9c9"];
            view.currentColor = [UIColor colorWithHexString:@"409FF3"];
        }
        
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
    }];
}



- (void)setupBugly {
    //bug采集
    [Bugly startWithAppId:BUGLY_APP_ID];
    BuglyConfig * config = [[BuglyConfig alloc] init];
    config.debugMode = YES;
    config.blockMonitorEnable = YES;
    config.blockMonitorTimeout = 1.5;
    config.channel = @"iOS";
    config.delegate = self;
    config.consolelogEnable = YES;
    config.viewControllerTrackingEnable = YES;
    [Bugly startWithAppId:BUGLY_APP_ID
#if DEBUG
        developmentDevice:YES
#endif
                   config:config];
    [Bugly setUserIdentifier:[NSString stringWithFormat:@"User: %@", [UIDevice currentDevice].name]];
     [Bugly setUserValue:[NSProcessInfo processInfo].processName forKey:@"Process"];
//    [self performSelectorInBackground:@selector(testLogOnBackground) withObject:nil];
    [BuglyLog initLogger:BuglyLogLevelDebug consolePrint:NO];
}

/**
 *    @brief TEST method for BuglyLog
 */
- (void)testLogOnBackground {
    int cnt = 0;
    while (1) {
        cnt++;
        
        switch (cnt % 5) {
            case 0:
                BLYLogError(@"Test Log Print %d", cnt);
                break;
            case 4:
                BLYLogWarn(@"Test Log Print %d", cnt);
                break;
            case 3:
                BLYLogInfo(@"Test Log Print %d", cnt);
                BLYLogv(BuglyLogLevelWarn, @"BLLogv: Test", NULL);
                break;
            case 2:
                BLYLogDebug(@"Test Log Print %d", cnt);
                BLYLog(BuglyLogLevelError, @"BLLog : %@", @"Test BLLog");
                break;
            case 1:
            default:
                BLYLogVerbose(@"Test Log Print %d", cnt);
                break;
        }
        
        // print log interval 1 sec.
        sleep(1);
    }
}


#pragma mark - BuglyDelegate
- (NSString *)attachmentForException:(NSException *)exception {
    NSLog(@"(%@:%d) %s %@",[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, __PRETTY_FUNCTION__,exception);
    return @"This is an attachment";
}

-(void)application:(UIApplication *) application didRegisterForRemoteNotificationsWithDeviceToken:(nonnull NSData *)deviceToken{
    [JPUSHService setBadge:0];
    [JPUSHService registerDeviceToken:deviceToken];
    //NSLog(@"注册deviceToken:%@",deviceToken);
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSLog(@"AppDelegate willPresentNotification收到通知");
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
  

}


 // iOS 10 Support 点击推送
 - (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
     NSDictionary * userInfo = response.notification.request.content.userInfo;
     NSLog(@"AppDelegate didReceiveNotificationResponse点击通知%@",userInfo);
     if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
         [JPUSHService handleRemoteNotification:userInfo];
     }
     [JPUSHService setBadge:0];
     completionHandler();  // 系统要求执行这个方法
     //    NSLog(@"%@",userInfo);
     NSMutableDictionary *notDic = [NSMutableDictionary dictionary];
     
     //第二种情况后台挂起时
     [[NSNotificationCenter defaultCenter]postNotificationName:@"alertMessage" object:nil userInfo:userInfo];
     
 }


/**
 颜色转图片
 
 @param color 颜色
 @return 图片
 */
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



- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // Required,For systems with less than or equal to iOS6
    [JPUSHService handleRemoteNotification:userInfo];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter]
     postNotificationName:kApplicationGoesToTheForegroundNotification object:nil];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UIApplication sharedApplication].applicationIconBadgeNumber=0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    NSLog(@"appdelegate tabBarController shouldSelectViewController %@ %lu",viewController.title,(unsigned long)tabBarController.selectedIndex);
    if([viewController.title isEqualToString:@"台站管理"]||[viewController.title isEqualToString:@"告警管理"]){
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        if(![userDefaults objectForKey:@"station"]){
            if(tabBarController.selectedIndex != 0){
                [tabBarController setSelectedIndex:0];
                tabBarController.selectedIndex = 0;
                tabBarController.tabBarController.selectedIndex = 0;
            }
            
            [FrameBaseRequest showMessage:@"请选择台站"];
            
            
            return NO;
        }
        return YES;
    }else{
        return YES;
    }
}
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    NSLog(@"appdelegate didSelectItem %@",item.title);
    /*
    if([item.title isEqualToString:@"告警管理"]){
        
        return ;
    }
     */
}

@end
