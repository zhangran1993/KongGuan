
//
//  LCChunhui.h
//  ylh-app-primary-ios
//
//  Created by zhangran on 2018/8/29.
//  Copyright © 2018年 巨商汇. All rights reserved.
//

#ifndef LCChunhui_h
#define LCChunhui_h

#import "UIImage+RSMethod.h"
#import "NSObject+SafeMethod.h"
#import "MJExtension.h"
#import "NSArray+SMSafeMethod.h"
#import <Masonry.h>
#import <SDAutoLayout.h>
#import "RS_ColorManager.h"
#import "UserManager.h"
#import "WYLHTTPSessionManager.h"
#import "DataManager.h"
#import "MBProgressHUD.h"
#import "UIScrollView+EmptyDataSet.h"
#import "MJRefresh.h"
#import "MJExtension.h"
#import <UIImageView+WebCache.h>
#import "FrameBaseRequest.h"
#import "MBProgressHUD+XMG.h"
#import "NSString+RSMethod.h"
#import "NSString+MD5.h"
#import "TZImagePickerController.h"
#import "TZImageManager.h"
#import <Photos/Photos.h>
#import "FrameNavigationController.h"
#import "LoginViewController.h"
#import "UIViewController+YQSlideMenu.h"
#define XZShare [UtilsJSH standarInstance]
//MARK:判断手机机型
#define JSHmainWindow [UIApplication sharedApplication].keyWindow
// 判断是否为 iPhone 5SE
#define iPhone5SE [[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 568.0f
// 判断是否为iPhone 6/6s
#define iPhone6_6s [[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 667.0f
// 判断是否为iPhone 6Plus/6sPlus
#define iPhone6Plus_6sPlus [[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 736.0f
// 判断是否为iPhoneX,XS、XR及XSMAX
#define iPhoneX ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) ? YES : NO)
#define LCColor(hexColor)  [UIColor colorWithHexString:hexColor]

#define NAVIGATIONBAR_HEIGHT ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) ? 88.0 : 64.0)
#define kDefectHeight  (iPhoneX ? 34.0 : 0.0)
#define TABBAR_HEIGHT (iPhoneX ? (49+kDefectHeight) : 49)

#define smWeak(object)      autoreleasepool {} __weak __typeof(object) weak##_##object = object;
#define smStrong(object)    autoreleasepool {} __strong __typeof(object) object = weak##_##object;

#define weakify(object)     @smWeak(object)
#define strongify(object)   @smStrong(object)
#define WS(weakSelf) __weak __typeof(&*self) weakSelf = self;
//根据十进制颜色和不透明度设置颜色
#define RGBA(r, g, b, a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]
//十进制颜色
#define RGB(r, g, b) RGBA(r, g, b, 1.0f)

/**生成随机色*/
#define WYLAutoColor [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue:arc4random_uniform(255) / 255.0 alpha:1];



#define kShowMSG(text) [MBProgressHUD show:text toView:[UIApplication sharedApplication].keyWindow];

#define kWScale (SCREEN_WIDTH / 375.0)
#define kHScale (375.0 / SCREEN_WIDTH)

#define WidthScale SCREEN_WIDTH / 414.0
#define HeightScale SCREEN_HEIGHT / 736.0



#define WYLUserDefaults [NSUserDefaults standardUserDefaults]


#define kWScale (SCREEN_WIDTH / 375.0)
#define kHScale (375.0 / SCREEN_WIDTH)

#define WidthScale SCREEN_WIDTH / 414.0
#define HeightScale SCREEN_HEIGHT / 736.0

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

//状态栏高度
#define FBStatusBarH ([UIApplication sharedApplication].statusBarFrame.size.height)

//新城套一些颜色
#define kSetSeriesGreenGroundColor [UIColor colorWithRed:70 / 255.0 green:190 / 255.0 blue:137 / 255.0 alpha:1.0]
#define kSetSeriesRedGroundColor [UIColor colorWithRed:234 / 255.0 green:52 / 255.0 blue:37 / 255.0 alpha:1.0]
#define kThinRedGroundColor [UIColor colorWithRed:252 / 255.0 green:239 / 255.0 blue:238 / 255.0 alpha:1.0]
#define kGrayGroundColor [UIColor colorWithRed:242 / 255.0 green:242 / 255.0 blue:242 / 255.0 alpha:1.0]
#define kCellGrayGroundColor [UIColor colorWithRed:247 / 255.0 green:247 / 255.0 blue:247 / 255.0 alpha:1.0]
#define kFontColor [UIColor colorWithRed:85 / 255.0 green:85 / 255.0 blue:85 / 255.0 alpha:1.0]

//控件宽高屏幕适配
#define kAutoWidthSize(x) (x / 375.0) * [[UIScreen mainScreen] bounds].size.width
#define kAutoSize(x) (x / 667.0) * [[UIScreen mainScreen] bounds].size.height
#define kAspectRatio (kScreenWIDTH / kScreenHEIGHT)

#define kLightGrayColor [UIColor colorWithRed:241 / 255.0 green:241 / 255.0 blue:241 / 255.0 alpha:1.0]

//根据十进制颜色和不透明度设置颜色
#define RGBA(r, g, b, a) [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a]
//十进制颜色
#define RGB(r, g, b) RGBA(r, g, b, 1.0f)

/**生成随机色*/
#define WYLAutoColor [UIColor colorWithRed:arc4random_uniform(255) / 255.0 green:arc4random_uniform(255) / 255.0 blue:arc4random_uniform(255) / 255.0 alpha:1];

/**灰色*/
#define WYLGrayColor(v) RGB(v, v, v)

//十六进制颜色
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1]

//根据十六进制颜色和不透明度设置颜色
#define COLOR_RGB(rgbValue, a) [UIColor colorWithRed:((float)(((rgbValue)&0xFF0000) >> 16)) / 255.0 green:((float)(((rgbValue)&0xFF00) >> 8)) / 255.0 blue:((float)((rgbValue)&0xFF)) / 255.0 alpha:(a)]


#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IS_PAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//设置图片
#define IMAGE(img) [UIImage imageNamed:img]

//设置字体
#define Font(font) [UIFont systemFontOfSize:font]
#define FontBold(font) [UIFont boldSystemFontOfSize:font]
#define FONT_MIDEUM(s) [UIFont fontWithName:@"PingFang-SC-Medium" size:s]


/// 高度系数 812.0 是iPhoneX的高度尺寸，667.0表示是iPhone 8 的高度
#define WYLHeightCoefficient (SCREEN_HEIGHT == 812.0 ? 667.0 / 667.0 : SCREEN_HEIGHT / 667.0)

#define WYL_ViewSafeAreInsets(view) ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets; })

/**通过一张图片生成一张没有渲染的最原始的图片*/
#define WYLImage(pictureName) [[UIImage imageNamed:pictureName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

// 搜索的路径
#define KHistorySearchPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"PYSearchhistories.plist"]

//出样历史搜索的路径
#define ChuYangHistorySearchPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"ChuYangHistories.plist"]
//我的商品历史搜索路径
#define MyNewGoodsHistorySearchPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"MyNewGoodsHistories.plist"]

//储存token
#define SaveToken(value) [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"ylhToken"]
//获取token
#define ObtainToken [[NSUserDefaults standardUserDefaults] objectForKey:@"ylhToken"]
//存储authorization
#define SaveAuthorization(value) [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"authorization"]


#define SaveJSHSessionId(value) [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"jsh_session_id"]

#define ObtainJSHSessionId [[NSUserDefaults standardUserDefaults] objectForKey:@"jsh_session_id"]


#define SaveRememberMe(value) [[NSUserDefaults standardUserDefaults] setObject:value forKey:@"jsh-remember-me"]

#define ObtainRememberMe [[NSUserDefaults standardUserDefaults] objectForKey:@"jsh-remember-me"]


//获取登录用户名称
#define ObtainUserName [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"]
//获取登录密码
#define ObtainPassWord [[NSUserDefaults standardUserDefaults] objectForKey:@"passWord"]

//当前版本
#define THE_VERSION [[NSUserDefaults standardUserDefaults] objectForKey:@"version"] ? [[NSUserDefaults standardUserDefaults] objectForKey:@"version"] : @"1.0"


//判断手机系统的宏
#define ios(verson) ([UIDevice currentDevice].systemVersion.doubleValue >= (verson))

//打印json数据的宏
#ifdef DEBUG //开发阶段
#define NSLog(format, ...) printf("%s \n", [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String])
#else //发布阶段
#define NSLog(format, ...)
#endif

//MARK:判断手机机型

// 判断是否为 iPhone 5SE
#define iPhone5SE [[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 568.0f
// 判断是否为iPhone 6/6s
#define iPhone6_6s [[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 667.0f
// 判断是否为iPhone 6Plus/6sPlus
#define iPhone6Plus_6sPlus [[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 736.0f
// 判断是否为iPhoneX,XS、XR及XSMAX
#define iPhoneX ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) ? YES : NO)


//判断刘海屏
#define IsLiuHaiPing [[UIApplication sharedApplication] statusBarFrame].size.height == 44 ? YES : NO

/**正在加载数据,友好提示*/
#define DataLoadingTips [MBProgressHUD showMessage:@"正在加载数据,请稍后..." toView:JSHmainWindow];

/**数据加载失败,友好提示*/
#define kShowNoNetworkMSG [MBProgressHUD showError:@"请求出错，稍后重试。" toView:JSHmainWindow];

//随机小数
#define ReturnDouble [NSString stringWithFormat:@"%.17f", (double)arc4random() / 0x100000000]

/*****判断手机型号代码*****/
//判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

//判断iPhone5系列
#define kiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iPhone6系列
#define kiPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
//判断iphone6+系列
#define kiPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)


/*****判断navBar和tabBar代码*****/
//iPhoneX系列
//状态栏高度
#define Height_StatusBar ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) ? 44.0 : 20.0)
//底部安全区域高度
#define Height_BottomBar ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) ? 34.0 : 0.0)
//导航栏高度
#define Height_NavBar ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) ? 88.0 : 64.0)
//底部tabBar高度
#define Height_TabBar ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) ? 83.0 : 49.0)
//横屏安全区域距离:上:0,下:21,左:44,右:44
//左右安全距离
#define SafeAreaLeftRightMargin ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) ? 44.0 : 0.0)
//底部安全距离
#define SafeAreaBottomMargin ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) ? 21.0 : 0.0)

// 判断是否为iPhone x 或者 xs
//#define iPhoneX [[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 812.0f
// 判断是否为iPhone xr 或者 xs max
#define iPhoneXR [[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 896.0f
// 是全面屏手机
#define IS_FULL_SCREEN (iPhoneX || iPhoneXR)

// 全面屏适配 适配
// 状态栏高度
#define kStateBarHeight (isFullScreen ? 44.0 : 20.0)
// 导航栏高度
#define kNavigationBarHeight (kStateBarHeight + 44.0)
// 底部tabbar高度
#define kTabBarHeight (isFullScreen ? (49.0+34.0) : 49.0)

/*****判断navBar和tabBar代码*****/
typedef NS_ENUM(NSUInteger, PolicyDetailHeadViewType) {
    PolicyDetailHeaderTypePromotion,
    PolicyDetailHeaderTypeProduct,
    PolicyDetailHeaderTypeRebate
};

typedef NS_ENUM(NSUInteger, SC_InStockType) {
    SC_InStockTypeInbound,
    SC_InStockTypeOutStore,
    SC_InStockTypePurchaseInbound
};

typedef NS_ENUM(NSUInteger , SC_InboundListType) {
    SC_InboundListTypeAll = 0,  //入库全部
    SC_InboundListTypeWaiting,  // 待入库
    SC_InboundListTypeSection,  // 部分入库
    SC_InboundListTypeAlready,  // 已入库

    
    SC_OutStorehourseListTypeAll,  //出库全部
    SC_OutStorehourseListTypeWaiting,  // 待出库库
    SC_OutStorehourseListTypeSection,  //部分出库
    SC_OutStorehourseListTypeAlready,  //已出库
    
    
    
    
    SC_ListTypeObsolete   // 作废
    
};

#endif /* LCChunhui_h */
