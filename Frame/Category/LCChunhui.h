
//
//  LCChunhui.h
//  ylh-app-primary-ios
//
//  Created by 李春慧 on 2018/8/29.
//  Copyright © 2018年 巨商汇. All rights reserved.
//

#ifndef LCChunhui_h
#define LCChunhui_h


#import "NSObject+SafeMethod.h"
#import "MJExtension.h"
#import "NSArray+SMSafeMethod.h"
#import <Masonry.h>


#define LCColor(hexColor)  [UIColor colorWithHexString:hexColor]

#define NAVIGATIONBAR_HEIGHT (iPhoneX ? 88  : 64)
#define kDefectHeight  (iPhoneX ? 34.0 : 0.0)
#define TABBAR_HEIGHT (iPhoneX ? (49+kDefectHeight) : 49)

#define smWeak(object)      autoreleasepool {} __weak __typeof(object) weak##_##object = object;
#define smStrong(object)    autoreleasepool {} __strong __typeof(object) object = weak##_##object;

#define weakify(object)     @smWeak(object)
#define strongify(object)   @smStrong(object)
#define WS(weakSelf) __weak __typeof(&*self) weakSelf = self;




#define kShowMSG(text) [MBProgressHUD show:text toView:[UIApplication sharedApplication].keyWindow];




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
