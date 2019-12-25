//
//  AppDelegate.h
//   
//
//  Created by Hibaysoft on 17/7/4.
//  Copyright (c) 2018年 Hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    UINavigationController *navigationController;
    BMKMapManager* _mapManager;
}

+ (AppDelegate *)getAppDelegate;
@property (strong, nonatomic) UIWindow *window;
@end

