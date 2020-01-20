
//
//  LCChunhui.h
//  ylh-app-primary-ios
//
//  Created by zhangran on 2018/8/29.
//  Copyright © 2018年 巨商汇. All rights reserved.
//

#ifndef LCChunhui_h
#define LCChunhui_h


#import "NSObject+SafeMethod.h"
#import "MJExtension.h"
#import "NSArray+SMSafeMethod.h"
#import <Masonry.h>
#import <SDAutoLayout.h>
#import "RS_ColorManager.h"
#import "UserManager.h"
//MARK:判断手机机型

// 判断是否为 iPhone 5SE
#define iPhone5SE [[UIScreen mainScreen] bounds].size.width == 320.0f && [[UIScreen mainScreen] bounds].size.height == 568.0f
// 判断是否为iPhone 6/6s
#define iPhone6_6s [[UIScreen mainScreen] bounds].size.width == 375.0f && [[UIScreen mainScreen] bounds].size.height == 667.0f
// 判断是否为iPhone 6Plus/6sPlus
#define iPhone6Plus_6sPlus [[UIScreen mainScreen] bounds].size.width == 414.0f && [[UIScreen mainScreen] bounds].size.height == 736.0f
// 判断是否为iPhoneX,XS、XR及XSMAX
#define iPhoneX ((IS_IPHONE_X == YES || IS_IPHONE_Xr == YES || IS_IPHONE_Xs == YES || IS_IPHONE_Xs_Max == YES) ? YES : NO)
#define LCColor(hexColor)  [UIColor colorWithHexString:hexColor]

#define NAVIGATIONBAR_HEIGHT (iPhoneX ? 88  : 64)
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
